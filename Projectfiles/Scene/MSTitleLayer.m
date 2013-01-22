//
//  MSTitleLayer.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSTitleLayer.h"
#import "MSMatchLayer.h"

@interface MSTitleLayer()
- (void)onServerButtonPressed:(id)sender;
- (void)onClientButtonPressed:(id)sender;
@end

@implementation MSTitleLayer

- (id)init {
  self = [super init];
  if (self) {
    CCDirector* director = [CCDirector sharedDirector];
    CCLabelTTF* hostLabel = [CCLabelTTF labelWithString:@"Host" fontName:@"Helvetica" fontSize:24];
    CCLabelTTF* clientLabel = [CCLabelTTF labelWithString:@"Client" fontName:@"Helvetica" fontSize:24];
    CCMenuItemLabel* host = [CCMenuItemLabel itemWithLabel:hostLabel target:self selector:@selector(onServerButtonPressed:)];
    CCMenuItemLabel* client = [CCMenuItemLabel itemWithLabel:clientLabel target:self selector:@selector(onClientButtonPressed:)];
    CCMenu* menu = nil;
    if (director.currentDeviceIsIPad) {
      menu = [CCMenu menuWithItems:host, client, nil];
    } else if (director.currentPlatformIsIOS) {
      menu = [CCMenu menuWithItems:client, nil];
    }
    
    menu.position = director.screenCenter;
    [menu alignItemsVerticallyWithPadding:50];
    [self addChild:menu];
  }
  return self;
}

- (void)onServerButtonPressed:(id)sender {
  MSMatchLayer* layer = [[MSMatchLayer alloc] initWithServerOrClient:MSSessionTypeServer];
  CCScene* scene = [CCNode node];
  [scene addChild:layer];
  CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5f scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
}

- (void)onClientButtonPressed:(id)sender {
  MSMatchLayer* layer = [[MSMatchLayer alloc] initWithServerOrClient:MSSessionTypeClient];
  CCScene* scene = [CCNode node];
  [scene addChild:layer];
  CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5f scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
}

@end
