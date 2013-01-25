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
  MSContainerTagInitialInfo,  // サーバーから。初期プレイヤーを各クライアントに送信
  MSContainerTagPlayerState,  // クライアントから。更新された状態をサーバーに送信
  MSContainerTagPlayerStates, // サーバーから。全プレイヤーの状態を全クライアントに送信
  MSContainerTagPlayerGoal    // ゴール
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
  MSAngel* _angel;
}

- (id)initWithServerPeer:(NSString*)peer andClients:(CCArray*)peers;
- (MSPlayer*)playerWithPeerID:(NSString*)peerID;
- (void)update:(ccTime)dt;

@end
