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
    CCSprite* background = [CCSprite spriteWithFile:@"gameover.png"];
    [self addChild:background];
  }
  return self;
}

@end
