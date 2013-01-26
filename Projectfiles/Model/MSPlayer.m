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
  self = [super initWithFile:@"player0.png"];
  if (self) {
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
    [self scheduleUpdate];
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
  state.position = self.position;
  state.peerID = self.peerID;
  return state;
}

- (void)updateWithPlayerState:(MSPlayerState *)state {
  if ([state.peerID isEqualToString:self.peerID]) {
    self.position = state.position;
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
  const float animationDuration = 0.2f;
  float scrollSpeed = [KKConfig floatForKey:@"ScrollSpeed"];
  float fps = [[KKStartupConfig config] maxFrameRate];
  self.isRailChanging = YES; // レール切り替え中をONにする
  int x = direction == MSDirectionLeft ? -railWidth : railWidth;
  
  CCMoveBy* move = [CCMoveBy actionWithDuration:animationDuration position:ccp(x, fps * animationDuration * scrollSpeed)]; // レール切り替えアニメーション
  CCCallFuncN* off = [CCCallBlockN actionWithBlock:^(CCNode *node) { // アニメーション後、ブロックを呼んで、レール切り替え中フラグをOFFに
    MSPlayer* p = (MSPlayer*)node;
    p.isRailChanging = NO;
  }];
  [self runAction:[CCSequence actionOne:move two:off]]; // アクションの実装
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
  CCMoveBy* move = [CCMoveBy actionWithDuration:animationDuration position:ccp(x, railWidth * 2)]; // レール切り替えアニメーション
  CCCallFuncN* off = [CCCallBlockN actionWithBlock:^(CCNode *node) { // アニメーション後、ブロックを呼んで、ライン切り替え中フラグをOFFに
    MSPlayer* p = (MSPlayer*)node;
    p.isLineChanging = NO;
  }];
  [self runAction:[CCSequence actionOne:move two:off]]; // アクションの実装
  
}

@end
