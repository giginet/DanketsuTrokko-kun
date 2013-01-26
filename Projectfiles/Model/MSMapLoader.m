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
    _chips = [NSMutableDictionary dictionary];
  }
  return self;
}

- (MSTile*)tileWithLine:(int)line rail:(int)rail y:(int)y {
  int count = [_lines count];
  if (y < count) {
    int x = line * 3 + rail;
    NSValue* key = [NSValue valueWithCGPoint:CGPointMake(x, y)];
    if ([_chips objectForKey:key]) { // キャッシュにあるときはそのまま返す
      return [_chips objectForKey:key];
    } else { // ないときは新しく作る
      NSString* line = (NSString*)[_lines objectAtIndex:count - y - 1];
      NSString* chip = [line substringWithRange:NSMakeRange(x, 1)];
      MSTile* tile = [self tileWithString:chip];
      [_chips setObject:tile forKey:key];
      return tile;
    }
  }
  return nil;
}

- (MSTile*)tileWithString:(NSString *)chip {
  MSTileType type = MSTileTypeRail;
  if ([chip isEqualToString:@"."]) {
    type = MSTileTypeNone;
  } else if ([chip isEqualToString:@"B"]) {
    type = MSTileTypeBranchRight;
  }
  return [[MSTile alloc] initWithTileType:type];
}

- (int)height {
  return [_lines count];
}

@end
