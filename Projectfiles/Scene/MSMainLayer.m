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

@implementation MSMainLayer

- (id)initWithServerPeer:(NSString *)peer andClients:(CCArray *)peers {
  self = [super init];
  if (self) {
    _state = MSGameStateReady;
    KWSessionManager* manager = [KWSessionManager sharedManager];
    manager.delegate = self;
    _cameraNode = [CCNode node];
    _stage = [CCNode node];
    _players = [CCArray array];
    _angel = [[MSAngel alloc] initWithPeerID:peer];
    CCSprite* background = [CCSprite spriteWithFile:@"back.png"];
    
    [_stage addChild:background];
    [_cameraNode addChild:_stage];
    
    background.position = ccp(768 * 1.25 / 2.0f, 1024 * 1.25 / 2.0f);
    int no = 0;
    for (NSString* client in peers) {
      MSPlayer* player = [[MSPlayer alloc] initWithPeerID:client no:no];
      [_players addObject:player];
      [_stage addChild:player];
      player.position = ccp(128 + 256 * no, 100);
      ++no;
    }
    [self addChild:_cameraNode];
    [self scheduleUpdate];
  }
  return self;
}

- (void)update:(ccTime)dt {
  float scrollSpeed = [KKConfig floatForKey:@"ScrollSpeed"];
  if (_scroll < GOAL_POINT) {
    _scroll += scrollSpeed;
  }
  _stage.position = ccpSub(_stage.position, ccp(0, scrollSpeed));
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
