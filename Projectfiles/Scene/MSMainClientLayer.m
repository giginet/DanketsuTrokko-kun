//
//  MSMainClientLayer.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSMainClientLayer.h"

@implementation MSMainClientLayer

- (id)initWithServerPeer:(NSString *)peer andClients:(CCArray *)peers {
  self = [super initWithServerPeer:peer andClients:peers];
  if (self) {
    for (MSPlayer* player in _players) {
      if (player.isMine) {
        _myPlayer = player;
        break;
      }
    }
    [KKInput sharedInput].deviceMotionActive = YES;
  }
  return self;
}

- (void)update:(ccTime)dt {
  KKInput* input = [KKInput sharedInput];
  if ([input deviceMotionAvailable]) {
    float x = input.deviceMotion.pitch;
    float y = input.deviceMotion.roll;
    KWVector* vector = [KWVector vectorWithPoint:ccp(x, y)];
    _myPlayer.position = ccpSub(_myPlayer.position, [vector point]);
  }
}

@end
