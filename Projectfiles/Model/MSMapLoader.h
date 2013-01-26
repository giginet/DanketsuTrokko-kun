//
//  MSMapLoader.h
//  MultipleSession
//
//  Created by giginet on 1/26/13.
//
//

#import <Foundation/Foundation.h>
#import "MSTile.h"

/**
 Mapを読み込むクラスです
 */
@interface MSMapLoader : NSObject {
  NSArray* _lines;
  NSMutableDictionary* _chips;

  NSDictionary* _itemDictionary;
}

@property(readonly) int height;
@property(nonatomic,readonly) NSDictionary* itemDictionary;

- (MSTile*)tileWithLine:(int)line rail:(int)rail y:(int)y;

@end
