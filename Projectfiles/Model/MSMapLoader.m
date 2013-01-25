//
//  MSMapLoader.m
//  MultipleSession
//
//  Created by giginet on 1/26/13.
//
//

#import "MSMapLoader.h"

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

@end
