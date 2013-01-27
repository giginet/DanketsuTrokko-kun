//
//  MSGameOverLayer.m
//  MultipleSession
//
//  Created by giginet on 1/27/13.
//
//

#import "MSGameOverLayer.h"
#import "SimpleAudioEngine.h"

@implementation MSGameOverLayer

- (id)init {
  self = [super init];
  if (self) {
    CCDirector* director = [CCDirector sharedDirector];
    CCSprite* background = [CCSprite spriteWithFile:@"gameover.png"];
    background.position = director.screenCenter;
    [self addChild:background];
  }
  return self;
}

- (void)onEnterTransitionDidFinish {
  float volume = [KKConfig floatForKey:@"MusicVolume"];
  [SimpleAudioEngine sharedEngine].backgroundMusicVolume = volume;
  [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameover.caf"];
}

@end
