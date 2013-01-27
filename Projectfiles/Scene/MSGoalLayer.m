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

@interface MSGoalLayer()
- (void)onTitleButtonPressed:(id)sender;
@end

@implementation MSGoalLayer

- (id)initWithMainLayer:(MSMainLayer *)main {
  self = [super init];
  if (self) {
    self.mainLayer = main;
    CCDirector* director = [CCDirector sharedDirector];
    if (director.currentDeviceIsIPad) {
      CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:@"タイトル" fontName:@"Helvetica" fontSize:24];
      CCMenu* menu = [CCMenu menuWithItems:[CCMenuItemLabel itemWithLabel:titleLabel target:self selector:@selector(onTitleButtonPressed:)], nil];
      menu.position = ccp(director.screenCenter.x, 500);
      [self addChild:menu];
    }
    CCSprite* clear = [CCSprite spriteWithFile:@"clear.png"];
    clear.position = ccp(director.screenCenter.x, director.screenCenter.y * 1.5);
    [self addChild:clear];
  }
  return self;
}

- (void)onTitleButtonPressed:(id)sender {
  CCScene* scene = [MSTitleLayer nodeWithScene];
  CCTransitionCrossFade* fade = [CCTransitionCrossFade transitionWithDuration:0.5f scene:scene];
  [[CCDirector sharedDirector] replaceScene:fade];
  MSContainer* container = [MSContainer containerWithObject:nil forTag:MSContainerTagTitleButtonPressed];
  [self.mainLayer broadcastContainerToPlayer:container];
}

@end
