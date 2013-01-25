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
  self = [super initWithFile:@"ship.png"];
  if (self) {
    _peerID = peerID;
    _no = no;
    _isRailChanging = NO;
    KWSessionManager* manager = [KWSessionManager sharedManager];
    NSString* myPeerID = manager.session.peerID;
    _isMine = [_peerID isEqualToString:myPeerID];
    self.velocity = [KWVector vector];
    int scrollSpeed = [KKConfig intForKey:@"ScrollSpeed"];
    self.velocity.y = scrollSpeed;
    self.railNumber = 1; // 中央のレールから
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

@end
