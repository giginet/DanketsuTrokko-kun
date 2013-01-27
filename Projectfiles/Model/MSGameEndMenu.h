//
//  MSGameEndMenu.h
//  MultipleSession
//
//  Created by giginet on 1/27/13.
//
//

#import "CCMenu.h"
#import "MSMainLayer.h"

@interface MSGameEndMenu : CCMenu

- (id)initWithMainLayer:(MSMainLayer*)layer;

@property(readwrite) MSMainLayer* mainLayer;

@end
