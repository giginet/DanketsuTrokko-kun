//
//  MSGameOverLayer.m
//  MultipleSession
//
//  Created by giginet on 1/27/13.
//
//

#import "kobold2d.h"
#import "MSGameOverLayer.h"
#import "SimpleAudioEngine.h"
#import "KWSessionManager.h"
#import "MSTitleLayer.h"

@implementation MSGameOverLayer

- (id)init {
  self = [super init];
  if (self) {
    CCDirector* director = [CCDirector sharedDirector];
    CCSprite* background = [CCSprite spriteWithFile:@"gameover.png"];
    background.position = director.screenCenter;
    [self addChild:background];
    
    CCMenuItemImage* back = [CCMenuItemImage itemWithNormalImage:@"titleback.png"
                                                   selectedImage:@"titleback_pressed.png"
                                                          target:self
                                                        selector:@selector(onTitleButtonPressed:)];
    CCMenu* menu = [CCMenu menuWithItems:back, nil];
    if (director.currentDeviceIsIPad) {
      menu.position = ccp(director.screenCenter.x, 250);
    } else {
      menu.position = ccp(director.screenCenter.x, 125);
    }
    [self addChild:menu];
    
  }
  return self;
}

- (void)onEnterTransitionDidFinish {
  float volume = [KKConfig floatForKey:@"MusicVolume"];
  [SimpleAudioEngine sharedEngine].backgroundMusicVolume = volume;
  [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameover.caf"];
}

- (void)onTitleButtonPressed:(id)sender {
  CCScene* scene = [MSTitleLayer nodeWithScene];
  CCTransitionCrossFade* fade = [CCTransitionCrossFade transitionWithDuration:0.5f scene:scene];
  [[CCDirector sharedDirector] replaceScene:fade];
}

@end
