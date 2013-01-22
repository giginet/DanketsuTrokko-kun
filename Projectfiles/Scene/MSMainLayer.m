//
//  MSMainLayer.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSMainLayer.h"
#import "MSPlayer.h"

@implementation MSMainLayer

- (id)initWithServerPeer:(NSString *)peer andClients:(CCArray *)peers {
  self = [super init];
  if (self) {
    _stage = [CCNode node];
    _players = [CCArray array];
    _angel = [[MSAngel alloc] initWithPeerID:peer];
    int no = 0;
    for (NSString* client in peers) {
      MSPlayer* player = [[MSPlayer alloc] initWithPeerID:peer no:no];
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

@end
