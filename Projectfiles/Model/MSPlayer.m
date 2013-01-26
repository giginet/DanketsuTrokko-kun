//
//  MSPlayer.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSPlayer.h"
#import "KWSessionManager.h"

@implementation MSPlayer
@synthesize no = _no;
@synthesize isMine = _isMine;
@synthesize peerID = _peerID;

- (id)initWithPeerID:(NSString *)peerID no:(int)no {
  self = [super initWithFile:[NSString stringWithFormat:@"player%d.png", no]];
  if (self) {
    _coinCount = 0;
    _peerID = peerID;
    _no = no;
    self.isRailChanging = NO;
    self.isLineChanging = NO;
    KWSessionManager* manager = [KWSessionManager sharedManager];
    NSString* myPeerID = manager.session.peerID;
    _isMine = [_peerID isEqualToString:myPeerID];
    self.velocity = [KWVector vector];
    int scrollSpeed = [KKConfig intForKey:@"ScrollSpeed"];
    self.velocity.y = scrollSpeed;
    self.railNumber = 1; // 中央のレールから
    self.isRailChanged = NO;
    self.isGoal = NO;
    self.isCrashing = NO;
    self.life = 2; // 初期体力2ハードコード
    [self scheduleUpdate];
    [self updateRailAndLineNumber];
  }
  return self;
}

- (void)update:(ccTime)dt {
}

- (NSData*)dump {
  return [NSKeyedArchiver archivedDataWithRootObject:[self state]];
}

- (MSPlayerState*)state {
  MSPlayerState* state = [[MSPlayerState alloc] init];
  state.life = self.life;
  state.opacity = self.opacity;
  state.rotation = self.rotation;
  state.scale = self.scale;
  state.position = self.position;
  state.peerID = self.peerID;
  return state;
}

- (void)updateWithPlayerState:(MSPlayerState *)state {
  if ([state.peerID isEqualToString:self.peerID]) {
    self.life = state.life;
    self.opacity = state.opacity;
    self.position = state.position;
    self.scale = state.scale;
    self.rotation = state.rotation;
  }
}

- (void)updateRailAndLineNumber {
  float x = self.position.x;
  float lineWidth = [KKConfig intForKey:@"LineWidth"];
  float railWidth = [KKConfig intForKey:@"RailWidth"];
  self.lineNumber = floor(self.position.x / lineWidth);
  self.railNumber = floor((x - self.lineNumber * lineWidth) / railWidth);
}

- (void)setRailChangeAction:(MSDirection)direction {
  if ((self.railNumber == 0 && direction == MSDirectionLeft) || (self.railNumber == 2 && direction == MSDirectionRight)) return; // 左端、右端だったらはみ出さないようにする
  int railWidth = [KKConfig intForKey:@"RailWidth"];
  const float animationDuration = 0.6f;
  float scrollSpeed = [KKConfig floatForKey:@"ScrollSpeed"];
  float fps = [[KKStartupConfig config] maxFrameRate];
  self.isRailChanging = YES; // レール切り替え中をONにする
  int x = direction == MSDirectionLeft ? -railWidth : railWidth;
  
  CCMoveBy* move = [CCMoveBy actionWithDuration:animationDuration position:ccp(x, fps * animationDuration * scrollSpeed)]; // レール切り替えアニメーション
  id jump = [CCSequence actionOne:[CCEaseSineIn actionWithAction:[CCScaleTo actionWithDuration:animationDuration / 2.0 scale:1.5f]]
                              two:[CCEaseSineOut actionWithAction:[CCScaleTo actionWithDuration:animationDuration / 2.0 scale:1.0f]]];
  CCCallFuncN* off = [CCCallBlockN actionWithBlock:^(CCNode *node) { // アニメーション後、ブロックを呼んで、レール切り替え中フラグをOFFに
    MSPlayer* p = (MSPlayer*)node;
    p.isRailChanging = NO;
  }];
  [self runAction:[CCSequence actionOne:[CCSpawn actionOne:move two:jump] two:off]]; // アクションの実装
}

- (void)setLineChangeAction:(MSDirection)direction {
  BOOL canRight = self.lineNumber != 2 && self.railNumber == 2;
  BOOL canLeft = self.lineNumber != 0 && self.railNumber == 0;
  if ( (direction == MSDirectionRight && !canRight) || (direction == MSDirectionLeft && !canLeft) ) return;
  int railWidth = [KKConfig intForKey:@"RailWidth"];
  int margin = [KKConfig intForKey:@"Margin"];
  const float animationDuration = 0.5f;
  float scrollSpeed = [KKConfig floatForKey:@"ScrollSpeed"];
  float fps = [[KKStartupConfig config] maxFrameRate];
  
  self.isLineChanging = YES; // ライン切り替え中をONにする
  int distance = margin * 2 + railWidth;
  int x = direction == MSDirectionLeft ? -distance : distance;
  
  self.isRailChanged = YES;
  CCMoveBy* move = [CCMoveBy actionWithDuration:animationDuration position:ccp(x, railWidth * 1.5)]; // レール切り替えアニメーション
  CCCallFuncN* off = [CCCallBlockN actionWithBlock:^(CCNode *node) { // アニメーション後、ブロックを呼んで、ライン切り替え中フラグをOFFに
    MSPlayer* p = (MSPlayer*)node;
    p.isLineChanging = NO;
  }];
  [self runAction:[CCSequence actionOne:move two:off]]; // アクションの実装
  
}

- (void)setCrashAnimation {
  self.isCrashing = YES;
  id crash = [CCRepeat actionWithAction:[CCRotateBy actionWithDuration:0.5 angle:360] times:3];
  id blink = [CCRepeat actionWithAction:[CCSequence actionOne:[CCFadeTo actionWithDuration:0.05 opacity:128]
                                                          two:[CCFadeTo actionWithDuration:0.05 opacity:255]] times:5];
  id call = [CCCallBlockN actionWithBlock:^(CCNode *node) {
    MSPlayer* player = (MSPlayer*)node;
    self.rotation = 0;
    player.isCrashing = NO;
    float speed = [KKConfig floatForKey:@"ScrollSpeed"];
    player.velocity.y = speed;
  }];
  [self runAction:[CCSequence actionOne:[CCSpawn actionOne:crash two:blink] two:call]];
}

- (BOOL)canMoving {
  return !self.isRailChanging && !self.isLineChanging && !self.isCrashing;
}

- (BOOL)isDead {
  return self.life <= 0;
}

@end
