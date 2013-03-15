//
//  MSTile.h
//  MultipleSession
//
//  Created by giginet on 1/26/13.
//
//

#import "CCSprite.h"

typedef enum {
   MSTileTypeNone
  ,MSTileTypeRail
  ,MSTileTypeBranch
  ,MSTileTypeBranchLeft
  ,MSTileTypeBranchRight
  ,MSTileTypeRock
  ,MSTileTypeRuinRock
  ,MSTileTypeBrokenRock
  ,MSTileTypeCoin
} MSTileType;

@interface MSTile : CCNode {
    MSTileType _tileType;
}

- (id)initWithTileType:(MSTileType)type;
- (void)setTileType:(MSTileType)type;
- (void)addRockBreakAnimation;
- (void)addBranch:(CCNode*)node pos:(CGPoint)origin z:(int)z;

@property(nonatomic, readonly) MSTileType tileType;

@end
