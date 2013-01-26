//
//  MSPlayerState.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSPlayerState.h"

@implementation MSPlayerState

- (void)encodeWithCoder:(NSCoder*)coder {
  [coder encodeInt:self.life forKey:@"life"];
  [coder encodeFloat:self.opacity forKey:@"opacity"];
  [coder encodeFloat:self.scale forKey:@"scale"];
  [coder encodeFloat:self.rotation forKey:@"rotation"];
  [coder encodeCGPoint:self.position forKey:@"position"];
  [coder encodeObject:self.peerID forKey:@"peerID"];
}
- (id)initWithCoder:(NSCoder*)decoder {
  self = [super init];
  if (self) {
    self.life = [decoder decodeIntegerForKey:@"life"];
    self.opacity = [decoder decodeFloatForKey:@"opacity"];
    self.scale = [decoder decodeFloatForKey:@"scale"];
    self.rotation = [decoder decodeFloatForKey:@"rotation"];
    self.position = [decoder decodeCGPointForKey:@"position"];
    self.peerID = [decoder decodeObjectForKey:@"peerID"];
  }
  return self;
}

+ (MSPlayerState*)stateWithData:(NSData *)data {
  return (MSPlayerState*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
