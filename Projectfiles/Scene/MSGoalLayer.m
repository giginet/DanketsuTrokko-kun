//
//  MSGoalLayer.m
//  MultipleSession
//
//  Created by giginet on 1/26/13.
//
//

#import "MSGoalLayer.h"
#import "MSTitleLayer.h"

@interface MSGoalLayer()
- (void)onTitleButtonPressed:(id)sender;
@end

@implementation MSGoalLayer

- (id)init {
  self = [super init];
  if (self) {
    CCDirector* director = [CCDirector sharedDirector];
    if (director.currentDeviceIsIPad) {
      CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:@"タイトル" fontName:@"Helvetica" fontSize:24];
      CCMenu* menu = [CCMenu menuWithItems:[CCMenuItemLabel itemWithLabel:titleLabel target:self selector:@selector(onTitleButtonPressed:)], nil];
      menu.position = ccp(director.screenCenter.x, 500);
      [self addChild:menu];
    }
    CCLabelTTF* goalLabel = [CCLabelTTF labelWithString:@"Goal" fontName:@"Helvetica" fontSize:48];
    goalLabel.position = ccp(director.screenCenter.x, director.screenCenter.y * 1.5);
    [self addChild:goalLabel];
  }
  return self;
}

- (void)onTitleButtonPressed:(id)sender {
  CCScene* scene = [MSTitleLayer nodeWithScene];
  CCTransitionCrossFade* fade = [CCTransitionCrossFade transitionWithDuration:0.5f scene:scene];
  [[CCDirector sharedDirector] replaceScene:fade];
}

@end
