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
    [self setTileType:type];
  }
  return self;
}

- (MSTileType) tile
{
  return _tileType;
}

- (void)setTileType:(MSTileType)type {
  [self removeAllChildrenWithCleanup:YES];
  int railWidth = [KKConfig intForKey:@"RailWidth"];
  int margin = [KKConfig intForKey:@"Margin"];
  _tileType = type;
  if (type != MSTileTypeNone) {
    CCSprite* rail = [CCSprite spriteWithFile:@"rail0.png"];
    [self addChild:rail];
    
    switch (type) {
      case MSTileTypeCoin:
      {
        NSString* fileName = @"coin.png";
        CCSprite* object = [CCSprite spriteWithFile:fileName];
        [self addChild:object];
      }
        break;
      case MSTileTypeRock:
      {
        NSString* fileName = @"rock.png";
        CCSprite* object = [CCSprite spriteWithFile:fileName];
#define ROCK_ID 1
        object.tag = ROCK_ID;
        [self addChild:object];
      }
        break;
      case MSTileTypeRuinRock:
      {
        [self removeChildByTag:ROCK_ID cleanup:YES];
//#define ROCK_ID 2
//        NSString* fileName = @"rock.png";
//        CCSprite* object = [CCSprite spriteWithFile:fileName];
//        [self addChild:object];
      }
        break;
      case MSTileTypeBrokenRock:
      {
        
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

- (void)addRockBreakAnimation {
  CCSprite* rockBreak = [CCSprite spriteWithFile:@"rock_break.png"];
  [rockBreak runAction:[CCSequence actions:
                        [CCFadeOut actionWithDuration:2.0f],
                        [CCRemoveFromParentAction action],
                        nil]];
  [self addChild:rockBreak];
}

@end
