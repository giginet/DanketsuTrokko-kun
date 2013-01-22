//
//  MSMainLayer.h
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "CCLayer.h"
#import "MSAngel.h"

@interface MSMainLayer : CCLayer {
  CCCamera* _camera;
  CCArray* _players;
  CCNode* _stage;
  MSAngel* _angel;
}

- (id)initWithServerPeer:(NSString*)peer andClients:(CCArray*)peers;

@end
