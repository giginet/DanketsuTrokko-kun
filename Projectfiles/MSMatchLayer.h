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
  NSArray* _clients;
}

- (id)initWithServerOrClient:(MSSessionType)type;

@end
