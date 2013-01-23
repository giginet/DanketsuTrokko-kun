//
//  MSPlayer.h
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "CCSprite.h"
#import "MSPlayerState.h"

@interface MSPlayer : CCSprite {
  int _no;
  BOOL _isMine;
  NSString* _peerID;
}

@property(readonly) int no;
@property(readonly) BOOL isMine;
@property(readonly, copy) NSString* peerID;

- (id)initWithPeerID:(NSString*)peerID no:(int)no;
- (NSData*)dump;
- (void)updateWithPlayerState:(MSPlayerState*)state;

@end
