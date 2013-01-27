//
//  MSMatchLayer.h
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "KWLayer.h"
#import "KWSessionManager.h"
#import "KWSessionDelegate.h"

typedef enum {
  MSSessionTypeClient,
  MSSessionTypeServer
} MSSessionType;

typedef enum {
  MSMatchContainerTagClients,
  MSMatchContainerTagServerPeer
} MSMatchContainerTag;

@interface MSMatchLayer : CCLayer <KWSessionDelegate> {
  MSSessionType _type;
  NSMutableDictionary* _peers;
  KWSessionManager* _sessionManager;
  CCLabelTTF* _stateLabel;
  CCNode* _peersNode;
  NSString* _serverPeerID;
  CCMenu* _startMenu;
  CCMenu* _demoMenu;
  NSArray* _clients;
  
  
  CCSprite* _lightServer;
  CCSprite* _lightClient;
  CCSprite* _lightClient2;
  CCSprite* _lightClient3;
  
  CCMenu* _menuStart;

}

- (id)initWithServerOrClient:(MSSessionType)type;

@end
