//
//  MSContainer.h
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import <Foundation/Foundation.h>

@interface MSContainer : NSObject <NSCoding> {
  int _tag;
  id<NSCoding> _object;
}

@property(readonly) int tag;
@property(readonly) id<NSCoding> object;

+ (MSContainer*)containerWithObject:(id<NSCoding>)object forTag:(int)tag;
- (id)initWithObject:(id<NSCoding>)object forTag:(int)tag;

@end
