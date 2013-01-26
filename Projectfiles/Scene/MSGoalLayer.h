//
//  MSGoalLayer.h
//  MultipleSession
//
//  Created by giginet on 1/26/13.
//
//

#import "CCLayer.h"
#import "MSMainLayer.h"

@interface MSGoalLayer : CCLayer

- (id)initWithMainLayer:(MSMainLayer*)main;

@property(readwrite) MSMainLayer* mainLayer;

@end
