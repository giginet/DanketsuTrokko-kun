//
//  MSMainServerLayer.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSMainServerLayer.h"
#import "KWSessionManager.h"

@interface MSMainServerLayer()
- (void)broadCastAllPlayers;
@end

@implementation MSMainServerLayer

- (id)initWithServerPeer:(NSString *)peer andClients:(CCArray *)peers {
  self = [super initWithServerPeer:peer andClients:peers];
  if (self) {
    self.scale = 0.8f; // iPad版はサイズを0.8倍にして扱う
  }
  return self;
}

- (void)update:(ccTime)dt {
  [super update:dt];
  CCDirector* director = [CCDirector sharedDirector];
  
  // ゴール判定
  for (MSPlayer* player in _players) {
    if (_scroll >= GOAL_POINT && player.position.y > director.screenCenter.y) { // ゴールになったとき、ゴールタグが付いたモノを送ります
      MSContainer* container = [MSContainer containerWithObject:nil forTag:MSContainerTagPlayerGoal];
      [self sendContainer:container peerID:player.peerID];
    }
  }
}

- (void)broadCastAllPlayers {
  KWSessionManager* manager = [KWSessionManager sharedManager];
  NSMutableArray* array = [NSMutableArray array];
  for (MSPlayer* player in _players) {
    [array addObject:[player state]];
  }
  MSContainer* container = [MSContainer containerWithObject:array forTag:MSContainerTagPlayerStates];
  NSData* data = [NSKeyedArchiver archivedDataWithRootObject:container];
  [manager broadCastData:data mode:GKSendDataUnreliable];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
  MSContainer* container = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  if (container.tag == MSContainerTagPlayerState) {
    MSPlayer* player = [self playerWithPeerID:peer];
    if (player) {
      MSPlayerState* state = (MSPlayerState*)container.object;
      [player updateWithPlayerState:state];
      [self broadCastAllPlayers];
    }
  }
}

@end
