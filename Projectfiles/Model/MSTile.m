//
//  MSTile.m
//  MultipleSession
//
//  Created by giginet on 1/26/13.
//
//

#import "MSTile.h"

@implementation MSTile

- (id)initWithTileType:(MSTileType)type {
  self = [super init];
  if (self) {
    int railWidth = [KKConfig intForKey:@"RailWidth"];
    int margin = [KKConfig intForKey:@"Margin"];
    int rockAndCoinWidth = [KKConfig intForKey:@"RockAndCoinWidth"];
    
    if (type != MSTileTypeNone) {
      CCSprite* rail = [CCSprite spriteWithFile:@"rail0.png"];
      //rail.position = ccp(tileSize / 2.0f, tileSize / 2.0f);
      //rail.anchorPoint = ccp(0.5f, 0.5f);
      [self addChild:rail];

        CGPoint pos = CGPointZero;
        NSString* fileName = @"";
      
        switch (type) {
        case MSTileTypeRock:
        case MSTileTypeCoin:
        {
            /*NSString**/ fileName = type == MSTileTypeRock ? @"coin.png" : @"iwa.png";
          pos = ccp(rockAndCoinWidth,rockAndCoinWidth);
          CCSprite* branch = [CCSprite spriteWithFile:fileName];
          branch.position = pos;
          [self addChild:branch];
        }
            break;
        case MSTileTypeBranchRight:
        case MSTileTypeBranchLeft:
        {
          if (type == MSTileTypeBranchRight || type == MSTileTypeBranchLeft) {
            NSString* fileName = @"";
            CGPoint pos = CGPointZero;
            const int frameWidth = 10;
            if (type == MSTileTypeBranchLeft) {
              fileName = @"branch-left.png";
              pos = ccp(- 2 * margin - frameWidth, railWidth);
            } else if (type == MSTileTypeBranchRight) {
              fileName = @"branch-right.png";
              pos = ccp(2 * margin + frameWidth, railWidth);
            }
            CCSprite* branch = [CCSprite spriteWithFile:fileName];
            branch.position = pos;
            [self addChild:branch];
          }
        }
            break;
    default:
            break;
        }
      
    }
  }
  return self;
}

- (MSTileType) tile
{
    return _tileType;
}






@end
