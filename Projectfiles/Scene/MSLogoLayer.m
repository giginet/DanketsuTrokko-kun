//
//  MSLogoLayer.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSLogoLayer.h"
#import "MSTitleLayer.h"

@implementation MSLogoLayer

- (id)init {
  self = [super initWithNext:[MSTitleLayer class]];
  return self;
}

@end
