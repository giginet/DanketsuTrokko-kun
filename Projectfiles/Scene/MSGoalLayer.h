//
//  MSGoalLayer.h
//  MultipleSession
//
//  Created by giginet on 1/26/13.
//
//

#import "CCLayer.h"
#import "MSMainLayer.h"
#import "KWSessionDelegate.h"

@interface MSGoalLayer : CCLayer <KWSessionDelegate>

- (id)initWithMainLayer:(MSMainLayer*)main;

@property(readwrite, weak) MSMainLayer* mainLayer;

@end
