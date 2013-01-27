//
//  MSMainLayer.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSMainLayer.h"
#import "MSErrorLayer.h"
#import "KWSessionManager.h"
#import "MSTile.h"
#import "DummyManager.h"
#import "MSGameOverLayer.h"
#import "SimpleAudioEngine.h"
#import "KWRandom.h"

typedef enum {
  MSMainLayerZOrderBackground = 0,
  MSMainLayerZOrderRail = 1,
  MSMainLayerZOrderPlayer = 2
} MSMainLayerZOrder;

@implementation MSMainLayer

- (id)initWithServerPeer:(NSString *)peer andClients:(CCArray *)peers {
  self = [super init];
  if (self) {
    CCDirector* director = [CCDirector sharedDirector];
    _state = MSGameStateReady;
    
    _loader = [[MSMapLoader alloc] init];
    
    if( [peer compare:[DummyManager serverID]] == NSOrderedSame ){
      KWSessionManager* manager = [KWSessionManager sharedManager];
      manager.delegate = self;
    }else{
      
      
    }
    
    
    KWSessionManager* manager = [KWSessionManager sharedManager];
    manager.delegate = self;
    _cameraNode = [CCNode node];
    _stage = [CCNode node];
    _players = [CCArray array                                                                                                                                                                                          ];
    _angel = [[MSAngel alloc] initWithPeerID:peer];
    [_cameraNode addChild:_stage];
    [self buildMap];
    int no = 0;
    for (NSString* client in peers) {
      MSPlayer* player = [[MSPlayer alloc] initWithPeerID:client no:no];
      [_players addObject:player];
      [_stage addChild:player z:MSMainLayerZOrderPlayer];
      player.position = ccp(320 * no + 28 + 88 + 44, 260);
      ++no;
    }
    [self addChild:_cameraNode];
    [self scheduleUpdate];
    
    _scrollDebugLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Helvetica" fontSize:16];
    _scrollDebugLabel.position = ccp(50, 50);
    [self addChild:_scrollDebugLabel];
    
    if (director.currentDeviceIsIPad) {
      CCSprite* slash = [CCSprite spriteWithFile:@"slash.png"];
      slash.position = ccp(director.screenCenter.x, 30);
      _coinLabel = [CCLabelAtlas labelWithString:@"000" charMapFile:@"number.png" itemWidth:44 itemHeight:88 startCharMap:'0'];
      _coinLabel.position = ccp(director.screenCenter.x - 150, -16);
      _coinAllLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d", [_loader coinCount]] charMapFile:@"number.png" itemWidth:44 itemHeight:88 startCharMap:'0'];
      _coinAllLabel.position = ccp(director.screenCenter.x + 10, -16);
      CCSprite* icon = [CCSprite spriteWithFile:@"coinicon.png"];
      icon.position = ccp(director.screenCenter.x - 200, 30);
      [self addChild:slash];
      [self addChild:_coinLabel];
      [self addChild:_coinAllLabel];
      [self addChild:icon];
    } else {
      CCSprite* slash = [CCSprite spriteWithFile:@"slash.png"];
      slash.position = ccp(director.screenCenter.x, 15);
      _coinLabel = [CCLabelAtlas labelWithString:@"000" charMapFile:@"number.png" itemWidth:22 itemHeight:44 startCharMap:'0'];
      _coinLabel.position = ccp(director.screenCenter.x - 74, -6);
      _coinAllLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d", [_loader coinCount]] charMapFile:@"number.png" itemWidth:22 itemHeight:44 startCharMap:'0'];
      _coinAllLabel.position = ccp(director.screenCenter.x + 7, -6);
      CCSprite* icon = [CCSprite spriteWithFile:@"coinicon.png"];
      icon.position = ccp(director.screenCenter.x - 93, 15);
      [self addChild:slash];
      [self addChild:_coinLabel];
      [self addChild:_coinAllLabel];
      [self addChild:icon];
    }
  }
  return self;
}

- (void)onEnterTransitionDidFinish {
  [super onEnterTransitionDidFinish];
  [self buildReadyAnimation];
}

- (void)buildMap {
  for (int y = 0; y < [_loader height]; ++y) {
    for (int x = 0; x < 9; ++x) {
      int line = floor(x / 3);
      int rail = x % 3;
      const int tileSize = 88;
      const int margin = 28;
      MSTile* tile = [_loader tileWithLine:line rail:rail y:y];
      int ax = (margin * 2 + tileSize * 3) * line + margin + rail * tileSize;
      int ay = y * tileSize;
      CGPoint pos = ccpAdd(ccp(tileSize / 2, tileSize / 2), ccp(ax, ay));
      tile.position = pos;
      if (rail == 1) { // 背景の配置
        CCSprite* background = [CCSprite spriteWithFile:[NSString stringWithFormat:@"background%d.png", line]];
        background.position = pos;
        [_stage addChild:background z:MSMainLayerZOrderBackground];
      }
      [_stage addChild:tile z:MSMainLayerZOrderRail];
    }
  }
}

- (void)update:(ccTime)dt {
  [_scrollDebugLabel setString:[NSString stringWithFormat:@"%d", (int)_scroll                                                                                                                           ]];
  _stage.position = ccp(0, -_scroll); // スクロールを指定
  
  for (MSPlayer* player in _players) {
    [player updateRailAndLineNumber]; // レール番号、ライン番号を更新
  }
}

- (MSPlayer*)playerWithPeerID:(NSString *)peerID {
  for (MSPlayer* player in _players) {
    if ([player.peerID isEqualToString:peerID]) {
      return player;
    }
  }
  return nil;
}

- (void)sendContainer:(MSContainer *)container peerID:(NSString *)peerID {
  NSData* data = [NSKeyedArchiver archivedDataWithRootObject:container];
  KWSessionManager* manager = [KWSessionManager sharedManager];
  [manager sendDataToPeer:data to:peerID mode:GKSendDataUnreliable];
}

- (void)broadcastContainerToPlayer:(MSContainer *)container {
  for (MSPlayer* player in _players) {
    [self sendContainer:container peerID:player.peerID];
  }
}

- (void)updateCoinLabel {
  int sum = 0;
  for (MSPlayer* player in _players) {
    sum += player.coinCount;
  }
  [_coinLabel setString:[NSString stringWithFormat:@"%03d", sum]];
}

- (void)buildReadyAnimation {
  CCDirector* director = [CCDirector sharedDirector];
  _startLabel = [CCSprite spriteWithFile:@"count3.png"];
  _startLabel.scale = 0.0f;
  _startLabel.position = director.screenCenter;
  BOOL isServer = self.isServer;
  // 共通アクションを定義
  NSMutableArray* actions = [NSMutableArray arrayWithObjects:
                             [CCCallBlock actionWithBlock:^{
    if (isServer) {
      [[SimpleAudioEngine sharedEngine] playEffect:@"count.caf"];
    }
  }],
                             [CCScaleTo actionWithDuration:0.1f scale:1.0],
                             [CCDelayTime actionWithDuration:0.9f],
                             [CCCallBlockN actionWithBlock:^(CCNode *node) {
    CCSprite* label = (CCSprite*)node;
    [label setTexture:[[CCTextureCache sharedTextureCache] addImage:@"count2.png"]];
    if (isServer) {
      [[SimpleAudioEngine sharedEngine] playEffect:@"count.caf"];
    }
    label.scale = 0.0;
  }],
                             [CCScaleTo actionWithDuration:0.1f scale:1.0],
                             [CCDelayTime actionWithDuration:0.9f],
                             [CCCallBlockN actionWithBlock:^(CCNode *node) {
    CCSprite* label = (CCSprite*)node;
    if (isServer) {
      [[SimpleAudioEngine sharedEngine] playEffect:@"count.caf"];
    }
    [label setTexture:[[CCTextureCache sharedTextureCache] addImage:@"count1.png"]];
    label.scale = 0.0;
  }],
                             [CCScaleTo actionWithDuration:0.1f scale:1.0],
                             [CCDelayTime actionWithDuration:0.9f],
                             [CCCallBlockN actionWithBlock:^(CCNode *node) {
    CCSprite* label = (CCSprite*)node;
    CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:@"go.png"];
    [label setTexture:texture];
    [label setTextureRect:CGRectMake(0, 0, texture.contentSize.width, texture.contentSize.height)];
    [label setContentSize:texture.contentSize];
    label.scale = 0.0;
  }],
                             [CCScaleTo actionWithDuration:0.1f scale:1.0f],
                             nil];
  // サーバー固有アクションの追加
  if (self.isServer) {
    __block MSMainLayer* blockSelf = self;
    [actions addObject:[CCCallBlock actionWithBlock:^{
      // ゲーム開始時処理
      MSContainer* container = [MSContainer containerWithObject:nil forTag:MSContainerTagGameStart];
      [blockSelf broadcastContainerToPlayer:container];
      _state = MSGameStateMain;
      int n = [[KWRandom random] nextInt] % 2;
      NSLog(@"%d", n);
      [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[NSString stringWithFormat:@"main%d.caf", n] loop:YES];
    }]];
    [actions addObject:[CCDelayTime actionWithDuration:1.0f]];
    [actions addObject:[CCRemoveFromParentAction action]];
  }
  [_startLabel runAction:[CCSequence actionWithArray:actions]];
  [self addChild:_startLabel];
}

- (BOOL)isServer {
  if (_angel) {
    KWSessionManager* manager = [KWSessionManager sharedManager];
    return [_angel.peerID isEqualToString:manager.session.peerID];
  }
  return NO;
}

- (void)gotoGameOverScene {
  if (self.isServer) {
    float volume = [KKConfig floatForKey:@"MusicVolume"];
    id fadeout = [CCRepeat actionWithAction:[CCSequence
                                             actionOne:[CCCallBlock actionWithBlock:^{
      [SimpleAudioEngine sharedEngine].backgroundMusicVolume -= volume * 0.1;
    }]
                                             two:[CCDelayTime actionWithDuration:0.1f]]
                                      times:10];
    [self runAction:fadeout];
  }
  CCScene* scene = [MSGameOverLayer nodeWithScene];
  CCTransitionCrossFade* fade = [CCTransitionCrossFade transitionWithDuration:1.0f scene:scene];
  [[CCDirector sharedDirector] replaceScene:fade];
  KWSessionManager* manager = [KWSessionManager sharedManager];
  [manager.session disconnectFromAllPeers];
  manager.delegate = nil;
}

#pragma mark KWSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
  switch (state) {
    case GKPeerStateDisconnected:
    case GKPeerStateUnavailable:
      if ([peerID isEqualToString:_angel.peerID] || [self playerWithPeerID:peerID]) {
        CCScene* error = [MSErrorLayer nodeWithScene];
        [[CCDirector sharedDirector] replaceScene:error];
      }
      break;
    default:
      break;
  }
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
}

@end
