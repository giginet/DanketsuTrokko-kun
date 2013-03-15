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
#import "SimpleAudioEngine.h"
#import "KWSessionManager.h"

@implementation MSGoalLayer

- (id)initWithMainLayer:(MSMainLayer *)main {
  self = [super init];
  if (self) {
    self.mainLayer = main;
    CCDirector* director = [CCDirector sharedDirector];
    if (director.currentDeviceIsIPad) {
      CCMenuItemImage* retry = [CCMenuItemImage itemWithNormalImage:@"retry0.png"
                                                      selectedImage:@"retry1.png"
                                                             target:self
                                                           selector:@selector(onRetryButtonPressed:)];
      CCMenuItemImage* back = [CCMenuItemImage itemWithNormalImage:@"titleback.png"
                                                     selectedImage:@"titleback_pressed.png"
                                                            target:self
                                                          selector:@selector(onTitleButtonPressed:)];
      CCMenu* menu = [CCMenu menuWithItems:retry, back, nil];
      menu.position = ccp(director.screenCenter.x, 500);
      [menu alignItemsVerticallyWithPadding:30];
      [self addChild:menu];
    }
    CCSprite* clear = [CCSprite spriteWithFile:@"clear.png"];
    clear.position = ccp(director.screenCenter.x, director.screenCenter.y * 1.5);
    [self addChild:clear];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playEffect:@"result.caf"];
  }
  return self;
}

- (void)onTitleButtonPressed:(id)sender {
  if (self.mainLayer) {
    CCScene* scene = [MSTitleLayer nodeWithScene];
    CCTransitionCrossFade* fade = [CCTransitionCrossFade transitionWithDuration:0.5f scene:scene];
    [[CCDirector sharedDirector] replaceScene:fade];
    MSContainer* container = [MSContainer containerWithObject:nil forTag:MSContainerTagTitleButtonPressed];
    [self.mainLayer broadcastContainerToPlayer:container];
  }
}

- (void)onRetryButtonPressed:(id)sender {
}

@end
