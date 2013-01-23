//
//  MSErrorLayer.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSErrorLayer.h"
#import "MSTitleLayer.h"

@implementation MSErrorLayer

- (id)init {
  self = [super init];
  if (self) {
    CCLabelTTF* error = [CCLabelTTF labelWithString:@"接続エラーが発生しました" fontName:@"Helvetica" fontSize:24];
    CCDirector* director = [CCDirector sharedDirector];
    error.position = director.screenCenter;
    [self addChild:error];
    self.isTouchEnabled = YES;
  }
  return self;
}

- (void) registerWithTouchDispatcher{
  [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                            priority:0
                                                     swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  CCScene* scene = [MSTitleLayer nodeWithScene];
  CCTransitionCrossFade* fade = [CCTransitionCrossFade transitionWithDuration:0.5 scene:scene];
  [[CCDirector sharedDirector] replaceScene:fade];
}

@end
