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
  }
  return self;
}

@end
