//
//  MSGoalLayer.m
//  MultipleSession
//
//  Created by giginet on 1/26/13.
//
//

#import "MSGoalLayer.h"
#import "MSTitleLayer.h"
#import "MSContainer.h"
#import "MSGameEndMenu.h"

@implementation MSGoalLayer

- (id)initWithMainLayer:(MSMainLayer *)main {
  self = [super init];
  if (self) {
    self.mainLayer = main;
    CCDirector* director = [CCDirector sharedDirector];
    if (director.currentDeviceIsIPad) {
      MSGameEndMenu* menu = [[MSGameEndMenu alloc] initWithMainLayer:main];
      menu.position = ccp(director.screenCenter.x, 500);
      [self addChild:menu];
    }
    CCSprite* clear = [CCSprite spriteWithFile:@"clear.png"];
    clear.position = ccp(director.screenCenter.x, director.screenCenter.y * 1.5);
    [self addChild:clear];
  }
  return self;
}

@end
