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
#import "MSMap.h"

typedef enum {
  MSContainerTagInitialInfo,  // サーバーから。初期プレイヤーを各クライアントに送信
  MSContainerTagPlayerState,  // クライアントから。更新された状態をサーバーに送信
  MSContainerTagPlayerStates, // サーバーから。全プレイヤーの状態を全クライアントに送信
  MSContainerTagPlayerGoal,   // ゴール
  MSContainerTagScroll,       // サーバーから。現在のスクロール
  MSContainerTagGameEnd,      // サーバーから。ゲーム終わりました通知
  MSContainerTagTitleButtonPressed, // サーバーから。タイトルボタン押されました通知
  MSContainerTagGetCoin, // サーバーから。コイン取りました通知
  MSContainerTagRuinRock, // サーバから、クライアントへ岩の破壊通知
  MSContainerTagDamage,  // サーバーから、ダメージ受けました通知
  MSContainerTagGameStart,   // サーバーから、ゲームスタートしました通知を送信します
  MSContainerTagGameOver,    // サーバーから、ゲームオーバー通知
} MSContainerTag;

typedef enum {
  MSGameStateReady,
  MSGameStateMain,
  MSGameStateGameOver,
  MSGameStateClear
} MSGameState;

@interface MSMainLayer : CCLayer <KWSessionDelegate> {
  int _lastRow; // 直前のフレームの列です。変わってたときにマップを更新します。
  float _scroll;
  MSGameState _state;
  CCLabelAtlas* _coinLabel;
  CCLabelAtlas* _coinAllLabel;
  CCNode* _startLabel;
  CCArray* _players;
  CCNode* _stage;
  CCNode* _cameraNode;
  MSAngel* _angel;
  MSMap* _map;
  CCLabelTTF* _scrollDebugLabel;
}

@property(readonly) BOOL isServer;

- (id)initWithServerPeer:(NSString*)peer andClients:(CCArray*)peers;
- (void)sendContainer:(MSContainer*)container peerID:(NSString*)peerID; // peerIDにContainerを送信します
- (void)broadcastContainerToPlayer:(MSContainer*)container; // 全プレイヤーにコンテナを送信します
- (MSPlayer*)playerWithPeerID:(NSString*)peerID;
- (void)update:(ccTime)dt;
- (void)buildMap;
- (void)updateCoinLabel;
- (void)buildReadyAnimation;
- (void)gotoGameOverScene;
- (int)allCoinCount;
- (int)getSight;
- (void)updateSight;
- (void)updateHighScore;

@end
