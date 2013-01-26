//
//  MSGameOverLayer.m
//  MultipleSession
//
//  Created by giginet on 1/27/13.
//
//

#import "MSGameOverLayer.h"

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

@end
