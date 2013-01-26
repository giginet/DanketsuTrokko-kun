//
//  MSMapLoader.m
//  MultipleSession
//
//  Created by giginet on 1/26/13.
//
//

#import "MSMapLoader.h"

@interface MSMapLoader()
- (MSTile*)tileWithString:(NSString*)chip;
@end

@implementation MSMapLoader

- (id)init {
  self = [super init];
  if (self) {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"stage"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    _lines = [content componentsSeparatedByString:@"\n"];
  }
  return self;
}

- (MSTile*)tileWithLine:(int)line rail:(int)rail y:(int)y {
  int count = [_lines count];
  if (y < count) {
    int x = line * 3 + rail;
    NSLog(@"x = %d", x);
    NSString* line = (NSString*)[_lines objectAtIndex:count - y - 1];
    NSLog(@"%@", line);
    NSString* chip = [line substringWithRange:NSMakeRange(x, 1)];
    return [self tileWithString:chip];
  }
  return nil;
}

- (MSTile*)tileWithString:(NSString *)chip {
  MSTileType type = MSTileTypeRail;
  if ([chip isEqualToString:@"."]) {
    type = MSTileTypeNone;
  }
  return [[MSTile alloc] initWithTileType:type];
}

- (int)height {
  return [_lines count];
}

@end
