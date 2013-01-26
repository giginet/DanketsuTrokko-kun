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
  [coder encodeCGPoint:self.position forKey:@"position"];
  [coder encodeObject:self.peerID forKey:@"peerID"];
}
- (id)initWithCoder:(NSCoder*)decoder {
  self = [super init];
  if (self) {
    self.position = [decoder decodeCGPointForKey:@"position"];
    self.peerID = [decoder decodeObjectForKey:@"peerID"];
  }
  return self;
}

+ (MSPlayerState*)stateWithData:(NSData *)data {
  return (MSPlayerState*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
