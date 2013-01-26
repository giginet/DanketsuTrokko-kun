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
    _coinLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d/%d", 0, _loader.coinCount] fontName:@"Helvetica" fontSize:24];
    _coinLabel.position = ccp(director.screenCenter.x, 30);
    [self addChild:_coinLabel];
    
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
      player.position = ccp(320 * no + 28 + 88 + 44, 200);
      ++no;
    }
    [self addChild:_cameraNode];
    [self scheduleUpdate];
    
    _scrollDebugLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Helvetica" fontSize:16];
    _scrollDebugLabel.position = ccp(50, 50);
    [self addChild:_scrollDebugLabel];
  }
  return self;
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
  [_coinLabel setString:[NSString stringWithFormat:@"%d/%d", sum, _loader.coinCount]];
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
