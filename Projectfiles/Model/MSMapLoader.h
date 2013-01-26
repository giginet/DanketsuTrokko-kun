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
}

@property(readonly) int height;

/**
 Line, Rail, yから設置されているタイルを取ります
 */
- (MSTile*)tileWithLine:(int)line rail:(int)rail y:(int)y;

/**
 ステージ上の座標を元に、タイルを取ります。ない場合nilが返ります
 */
- (MSTile*)tileWithStagePoint:(CGPoint)point;

@end
