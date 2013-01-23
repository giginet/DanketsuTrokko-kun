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

- (void)update:(ccTime)dt {
}

- (void)broadCastAllPlayers {
  KWSessionManager* manager = [KWSessionManager sharedManager];
  NSMutableArray* array = [NSMutableArray array];
  for (MSPlayer* player in _players) {
    [array addObject:[player state]];
  }
  NSData* data = [NSKeyedArchiver archivedDataWithRootObject:array];
  [manager broadCastData:data mode:GKSendDataUnreliable];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
  MSPlayer* player = [self playerWithPeerID:peer];
  if (player) {
    [player updateWithPlayerState:[MSPlayerState stateWithData:data]];
    [self broadCastAllPlayers];
  }
}

@end
