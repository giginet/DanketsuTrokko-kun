//
//  MSLogoLayer.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSLogoLayer.h"
#import "HelloWorldLayer.h"

@implementation MSLogoLayer

- (id)init {
  self = [super initWithNext:[HelloWorldLayer class]];
  return self;
}

@end
