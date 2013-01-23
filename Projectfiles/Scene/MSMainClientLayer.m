//
//  MSMainClientLayer.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSMainClientLayer.h"
#import "KWSessionManager.h"

@interface MSMainClientLayer()
- (void)broadcastPlayer:(MSPlayer*)player;
@end

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
  CCDirector* director = [CCDirector sharedDirector];
  KKInput* input = [KKInput sharedInput];
  if ([input deviceMotionAvailable]) {
    float x = input.deviceMotion.pitch;
    float y = input.deviceMotion.roll;
    KWVector* vector = [KWVector vectorWithPoint:ccp(x, y)];
    _myPlayer.position = ccpSub(_myPlayer.position, [vector point]);
    float eyeX, eyeY, eyeZ;
    float centerX, centerY, centerZ;
    [_stage.camera centerX:&centerX centerY:&centerY centerZ:&centerZ];
    [_stage.camera eyeX:&eyeX eyeY:&eyeY eyeZ:&eyeZ];
    CGPoint player = ccpSub(_myPlayer.position, director.screenCenter);
    float playerX = player.x;
    float playerY = player.y;
    [_stage.camera setCenterX:playerX centerY:playerY centerZ:centerZ];
    [_stage.camera setEyeX:playerX eyeY:playerY eyeZ:eyeZ];
    [self broadcastPlayer:_myPlayer];
  }
}

- (void)broadcastPlayer:(MSPlayer *)player {
  KWSessionManager* manager = [KWSessionManager sharedManager];
  NSData* data = [player dump];
  [manager broadCastData:data mode:GKSendDataUnreliable];
}

@end
