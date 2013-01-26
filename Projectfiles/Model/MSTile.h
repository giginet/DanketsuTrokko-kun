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
  ,MSTileTypeCoin
} MSTileType;

@interface MSTile : CCNode {
    MSTileType _tileType;
}

- (id)initWithTileType:(MSTileType)type;

@property(nonatomic,readonly) MSTileType tile;

@end
