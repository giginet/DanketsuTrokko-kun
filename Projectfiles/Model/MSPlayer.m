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
    NSLog(@"%@, %@", peerID, myPeerID);
    _isMine = [_peerID isEqualToString:myPeerID];
    NSLog(@"%d", _isMine);
  }
  return self;
}

- (NSData*)dump {
  MSPlayerState* state = [[MSPlayerState alloc] init];
  state.position = self.position;
  return [NSKeyedArchiver archivedDataWithRootObject:state];
}

- (void)updateWithPlayerState:(MSPlayerState *)state {
  self.position = state.position;
}

@end
