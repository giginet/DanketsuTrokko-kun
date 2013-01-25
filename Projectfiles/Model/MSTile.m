//
//  MSTile.m
//  MultipleSession
//
//  Created by giginet on 1/26/13.
//
//

#import "MSTile.h"

@implementation MSTile

- (id)initWithTileType:(MSTileType)type {
  NSString* fileName = @"rail0.png";
  self = [super initWithFile:fileName];
  if (self) {
  }
  return self;
}

@end
