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
#import "MSMapLoader.h"

typedef enum {
  MSContainerTagInitialInfo,  // サーバーから。初期プレイヤーを各クライアントに送信
  MSContainerTagPlayerState,  // クライアントから。更新された状態をサーバーに送信
  MSContainerTagPlayerStates, // サーバーから。全プレイヤーの状態を全クライアントに送信
  MSContainerTagPlayerGoal,   // ゴール
  MSContainerTagScroll,       // サーバーから。現在のスクロール
} MSContainerTag;

typedef enum {
  MSGameStateReady,
  MSGameStateMain,
  MSGameStateGameOver,
  MSGameStateClear
} MSGameState;

@interface MSMainLayer : CCLayer <KWSessionDelegate> {
  float _scroll;
  MSGameState _state;
  CCArray* _players;
  CCNode* _stage;
  CCNode* _cameraNode;
  MSAngel* _angel;
  MSMapLoader* _loader;
  
  CCLabelTTF* _scrollDebugLabel;
}

- (id)initWithServerPeer:(NSString*)peer andClients:(CCArray*)peers;
- (void)sendContainer:(MSContainer*)container peerID:(NSString*)peerID; // peerIDにContainerを送信します
- (MSPlayer*)playerWithPeerID:(NSString*)peerID;
- (void)update:(ccTime)dt;
- (void)buildMap;

@end
