//
//  MSMainLayer.h
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "CCLayer.h"
#import "MSAngel.h"
#import "MSPlayer.h"
#import "MSContainer.h"
#import "KWSessionDelegate.h"

typedef enum {
  MSContainerTagInitialInfo,
  MSContainerTagPlayerState,
  MSContainerTagPlayerStates
} MSContainerTag;

@interface MSMainLayer : CCLayer <KWSessionDelegate> {
  CCCamera* _camera;
  CCArray* _players;
  CCNode* _stage;
  MSAngel* _angel;
}

- (id)initWithServerPeer:(NSString*)peer andClients:(CCArray*)peers;
- (MSPlayer*)playerWithPeerID:(NSString*)peerID;

@end
