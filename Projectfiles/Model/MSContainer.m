//
//  MSContainer.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSContainer.h"

@implementation MSContainer
@synthesize tag = _tag;
@synthesize object = _object;

- (id)initWithObject:(id<NSCoding>)object forTag:(int)tag {
  self = [super init];
  if (self) {
    _tag = tag;
    _object = object;
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    _tag = [aDecoder decodeIntForKey:@"tag"];
    _object = [aDecoder decodeObjectForKey:@"object"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeInt:self.tag forKey:@"tag"];
  [aCoder encodeObject:self.object forKey:@"object"];
}

@end
