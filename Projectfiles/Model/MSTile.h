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
  MSTileTypeBranch
} MSTileType;

@interface MSTile : CCSprite

- (id)initWithTileType:(MSTileType)type;

@end
