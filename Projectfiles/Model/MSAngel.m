//
//  MSAngel.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSAngel.h"

@implementation MSAngel
@synthesize peerID = _peerID;

- (id)initWithPeerID:(NSString *)peerID {
  self = [super init];
  if (self) {
    _peerID = peerID;
  }
  return self;
}

@end
