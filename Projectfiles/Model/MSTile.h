//
//  MSTile.h
//  MultipleSession
//
//  Created by giginet on 1/26/13.
//
//

#import "CCSprite.h"

typedef enum {
  MSTileTypeNone,
  MSTileTypeRail,
  MSTileTypeBranchLeft,
  MSTileTypeBranchRight,
  MSTileTypeRock,
  MSTileTypeCoin
} MSTileType;

@interface MSTile : CCNode

- (id)initWithTileType:(MSTileType)type;

@end
