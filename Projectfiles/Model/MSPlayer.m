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
    KWSessionManager* manager = [KWSessionManager sharedManager];
    NSString* myPeerID = manager.session.peerID;
    _isMine = [_peerID isEqualToString:myPeerID];
    self.velocity = [KWVector vector];
    self.velocity.y = SCROLL_SPEED;
    [self scheduleUpdate];
  }
  return self;
}

- (void)update:(ccTime)dt {
  self.position = ccpAdd(self.position, [_velocity point]);
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

@end
