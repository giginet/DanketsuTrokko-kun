//
//  MSMatchLayer.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSMatchLayer.h"

@interface MSMatchLayer()
- (void)updatePeerStateFor:(NSString*)peer toState:(GKPeerConnectionState)state;
@end

@implementation MSMatchLayer

NSString* kSessionID = @"MultipleMatch";

- (id)initWithServerOrClient:(MSSessionType)type {
  self = [super init];
  if (self) {
    CCDirector* director = [CCDirector sharedDirector];
    _type = type;
    _peers = [NSMutableDictionary dictionary];
    _sessionManager = [KWSessionManager sharedManager];
    [_sessionManager startSession:kSessionID sessionMode:type == MSSessionTypeClient ? GKSessionModeClient : GKSessionModeServer];
    _sessionManager.delegate = self;
    [_sessionManager available];
    if (_type == MSSessionTypeClient) {
      _stateLabel = [CCLabelTTF labelWithString:@"ホストを探しています" fontName:@"Helvetica" fontSize:24];
    } else {
      _stateLabel = [CCLabelTTF labelWithString:@"参加者を募集中" fontName:@"Helvetica" fontSize:24];
    }
    _stateLabel.position = ccp(director.screenCenter.x, 280);
    _stateLabel.color = ccc3(255, 255, 255);
    _peersNode = [CCNode node];
    _peersNode.position = director.screenCenter;
    [self addChild:_stateLabel];
    [self addChild:_peersNode];
    if (_type == MSSessionTypeServer) {
      _serverPeerID = _sessionManager.session.peerID;
    } else {
      _serverPeerID = @"";
    }
  }
  return self;
}

- (void)updatePeerStateFor:(NSString *)peer toState:(GKPeerConnectionState)state {
  if (state == GKPeerStateUnavailable) {
    [_peers removeObjectForKey:peer];
  } else {
    [_peers setObject:[NSNumber numberWithInt:state] forKey:peer];
    [_peersNode removeAllChildrenWithCleanup:YES];
    int count = 0;
    for (NSString* peerID in [_peers keyEnumerator]) {
      GKPeerConnectionState s = (GKPeerConnectionState)[(NSNumber*)[_peers objectForKey:peerID] intValue];
      NSString* peerName = [_sessionManager.session displayNameForPeer:peerID];
      CCLabelTTF* label = [CCLabelTTF labelWithString:peerName fontName:@"Helvetica" fontSize:16];
      label.position = ccp(0, count * 20);
      if ([_serverPeerID isEqualToString:peer]) {
        label.color = ccc3(0, 0, 255);
      } else if (s == GKPeerStateConnecting) {
        label.color = ccc3(255, 255, 0);
      } else if (s == GKPeerStateConnected) {
        label.color = ccc3(255, 0, 0);
      } else if (s == GKPeerStateDisconnected) {
        label.color = ccc3(128, 128, 128);
      } else {
        label.color = ccc3(255, 255, 255);
      }
      [_peersNode addChild:label];
      ++count;
    }
  }
}

#pragma mark KWSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
  NSString* stateName = @"";
  switch (state) {
    case GKPeerStateAvailable:
      stateName = @"Available";
      [_sessionManager connectToPeer:peerID];
      break;
    case GKPeerStateConnecting:
      stateName = @"Connecting";
      break;
    case GKPeerStateConnected:
      stateName = @"Connected";
      if (_type == MSSessionTypeClient) {
        [_stateLabel setString:@"ホストに接続しました"];
      } else {
        NSLog(@"%@", session.peerID);
        [_sessionManager broadCastString:_sessionManager.session.peerID mode:GKSendDataReliable];
      }
    default:
      break;
  }
  NSLog(@"%@, %@", [_sessionManager.session displayNameForPeer:peerID], stateName);
  [self updatePeerStateFor:peerID toState:state];
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
  [_sessionManager acceptConnectionFromPeer:peerID];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
  if (_type == MSSessionTypeClient) {
    _serverPeerID = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self updatePeerStateFor:peer toState:GKPeerStateConnected];
  }
}

@end
