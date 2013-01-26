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
    int tileSize = [KKConfig intForKey:@"RailWidth"];
    int margin = [KKConfig intForKey:@"Margin"];
    if (type == MSTileTypeBranchRight || type == MSTileTypeBranchLeft) {
      NSString* fileName = @"";
      CGPoint pos = CGPointZero;
      if (type == MSTileTypeBranchLeft) {
        fileName = @"branch-left.png";
        pos = ccp(tileSize * -2, 0);
      } else if (type == MSTileTypeBranchRight) {
        fileName = @"branch-right.png";
      }
      CCSprite* branch = [CCSprite spriteWithFile:fileName];
      //branch.anchorPoint = ccp(0.5f, 0.5f);
      branch.position = pos;
      [self addChild:branch];
    } else if (type != MSTileTypeNone) {
      CCSprite* rail = [CCSprite spriteWithFile:@"rail0.png"];
      //rail.position = ccp(tileSize / 2.0f, tileSize / 2.0f);
      //rail.anchorPoint = ccp(0.5f, 0.5f);
      [self addChild:rail];
    }
  }
  return self;
}

@end
