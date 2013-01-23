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
- (void)sendPlayerToServer:(MSPlayer*)player;
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
    float x = -input.deviceMotion.roll;
    float y = input.deviceMotion.pitch;
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
    [self sendPlayerToServer:_myPlayer];
  }
}

- (void)sendPlayerToServer:(MSPlayer *)player {
  KWSessionManager* manager = [KWSessionManager sharedManager];
  MSContainer* container = [MSContainer containerWithObject:[player state] forTag:MSContainerTagPlayerState];
  [manager sendDataToPeer:[NSKeyedArchiver archivedDataWithRootObject:container] to:_angel.peerID mode:GKSendDataUnreliable];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
  if ([peer isEqualToString:_angel.peerID]) { // サーバーから送られてきたとき
    MSContainer* container = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (container.tag == MSContainerTagPlayerStates) {
      NSArray* playerStates = (NSArray*)container.object;
      for (MSPlayerState* state in playerStates) {
        if (![_myPlayer.peerID isEqualToString:state.peerID]) { // 自分以外の時
          MSPlayer* player = [self playerWithPeerID:state.peerID];
          [player updateWithPlayerState:state];
        }
      }
    }
  }
}

@end
