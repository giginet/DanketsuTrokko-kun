//
//  MSTitleLayer.h
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "KWLayer.h"

@interface MSTitleLayer : CCLayer
{
  CCSprite* _spriteHelp;
  NSUInteger _helpIndex;
}

@property(readwrite) CCMenu* mainMenu;

@end
