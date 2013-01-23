//
//  MSMainLayer.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSMainLayer.h"
#import "KWSessionManager.h"

@implementation MSMainLayer

- (id)initWithServerPeer:(NSString *)peer andClients:(CCArray *)peers {
  self = [super init];
  if (self) {
    KWSessionManager* manager = [KWSessionManager sharedManager];
    manager.delegate = self;
    _stage = [CCNode node];
    _players = [CCArray array];
    _angel = [[MSAngel alloc] initWithPeerID:peer];
    CCSprite* background = [CCSprite spriteWithFile:@"background.jpg"];
    [_stage addChild:background];
    background.position = ccp(240, 150);
    int no = 0;
    for (NSString* client in peers) {
      MSPlayer* player = [[MSPlayer alloc] initWithPeerID:client no:no];
      [_players addObject:player];
      [_stage addChild:player];
      player.position = ccp(350 * no, 0);
      ++no;
    }
    [self addChild:_stage];
    [self scheduleUpdate];
  }
  return self;
}

- (void)update:(ccTime)dt {
}

- (MSPlayer*)playerWithPeerID:(NSString *)peerID {
  for (MSPlayer* player in _players) {
    if ([player.peerID isEqualToString:peerID]) {
      return player;
    }
  }
  return nil;
}

#pragma mark KWSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
  switch (state) {
    case GKPeerStateDisconnected:
      break;
    case GKPeerStateUnavailable:
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
