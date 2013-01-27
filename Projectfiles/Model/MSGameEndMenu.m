//
//  MSGameEndMenu.m
//  MultipleSession
//
//  Created by giginet on 1/27/13.
//
//

#import "MSGameEndMenu.h"
#import "MSTitleLayer.h"

@interface MSGameEndMenu()
- (void)onRetryButtonPressed:(id)sender;
- (void)onTitleButtonPressed:(id)sender;
@end

@implementation MSGameEndMenu

- (id)initWithMainLayer:(MSMainLayer *)layer {
  CCSprite* retry = [CCSprite spriteWithFile:@"retry0.png"];
  [retry runAction:[CCAnimate actionWithAnimation:
                    [CCAnimation animationWithFrames:@"retry%d.png" frameCount:2 delay:0.5f]]];
  CCMenuItemSprite* retryItem = [CCMenuItemSprite itemWithNormalSprite:retry
                                                        selectedSprite:retry
                                                                target:self
                                                              selector:@selector(onRetryButtonPressed:)];
  CCMenuItemImage* back = [CCMenuItemImage itemWithNormalImage:@"titleback.png"
                                                 selectedImage:@"titleback.png"
                                                        target:self
                                                      selector:@selector(onTitleButtonPressed:)];
  self = [super initWithArray:[NSArray arrayWithObjects:retryItem, back, nil]];
  if (self) {
    self.mainLayer = layer;
    
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
