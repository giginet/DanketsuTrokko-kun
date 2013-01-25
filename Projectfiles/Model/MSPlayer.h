//
//  MSPlayer.h
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "CCSprite.h"
#import "MSPlayerState.h"
#import "KWVector.h"
#import "KWTimer.h"

typedef enum {
  MSDirectionLeft,
  MSDirectionRight
} MSDirection;

@interface MSPlayer : CCSprite {
  int _no;
  BOOL _isMine;
  NSString* _peerID;
}

@property(readonly) int no; // キャラ番号0~2
@property(readonly) BOOL isMine; // 自分の操っているキャラかどうか
@property(readwrite) BOOL isRailChanging; // レール切り替え中かどうか
@property(readonly, copy) NSString* peerID; // PeerID
@property(readwrite, retain) KWVector* velocity; // 加速度

- (id)initWithPeerID:(NSString*)peerID no:(int)no;
- (void)update:(ccTime)dt;
- (NSData*)dump;
- (MSPlayerState*)state;
- (void)updateWithPlayerState:(MSPlayerState*)state;


/**
 レールの変更をするアクションを追加します
 @param MSDirection どちらのラインに移動するか
 */
- (void)setRailChangeAction:(MSDirection)direction;

@end
