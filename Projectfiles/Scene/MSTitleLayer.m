//
//  MSTitleLayer.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSTitleLayer.h"
#import "MSMatchLayer.h"
#import "SimpleAudioEngine.h"

@interface MSTitleLayer()
- (void)onServerButtonPressed:(id)sender;
- (void)onClientButtonPressed:(id)sender;
- (void)onHelpButtonPressed:(id)sender;
@end

@implementation MSTitleLayer

- (id)init {
  self = [super init];
  if (self) {
    CCDirector* director = [CCDirector sharedDirector];
    CCMenu* menu = nil;
    CCMenuItemImage* help = [CCMenuItemImage itemWithNormalImage:@"help.png"
                                                   selectedImage:@"help-on.png"
                                                   disabledImage:@"help-on.png"
                                                          target:self
                                                        selector:@selector(onHelpButtonPressed:)];
    if (director.currentDeviceIsIPad) {
      CCMenuItemImage* start = [CCMenuItemImage itemWithNormalImage:@"start.png"
                                                      selectedImage:@"start-on.png"
                                                      disabledImage:@"start-on.png"
                                                             target:self
                                                           selector:@selector(onServerButtonPressed:)];
      menu = [CCMenu menuWithItems:start, help, nil];
      menu.position = ccp(director.screenCenter.x, 200);
    } else if (director.currentPlatformIsIOS) {
      CCMenuItemImage* start = [CCMenuItemImage itemWithNormalImage:@"start.png"
                                                      selectedImage:@"start-on.png"
                                                      disabledImage:@"start-on.png"
                                                             target:self
                                                           selector:@selector(onClientButtonPressed:)];
      menu = [CCMenu menuWithItems:start, help, nil];
      menu.position = ccp(director.screenCenter.x, 150);
    }
    
    [menu alignItemsVerticallyWithPadding:25];
    
    CCSprite* title = [CCSprite spriteWithFile:@"title.png"];
    CCSprite* logo = [CCSprite spriteWithFile:@"logo.png"];
    title.position = director.screenCenter;
    logo.position = director.screenCenter;
    [self addChild:title];
    [self addChild:logo];
    
    [self addChild:menu];
  }
  return self;
}

- (void)onEnterTransitionDidFinish {
  [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"title.caf" loop:YES];
}

/**
 Hostボタンが押されたとき
 */
- (void)onServerButtonPressed:(id)sender {
  MSMatchLayer* layer = [[MSMatchLayer alloc] initWithServerOrClient:MSSessionTypeServer];
  CCScene* scene = [CCNode node];
  [scene addChild:layer];
  CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5f scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
  [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

/**
 Clientボタンが押されたとき
 */
- (void)onClientButtonPressed:(id)sender {
  MSMatchLayer* layer = [[MSMatchLayer alloc] initWithServerOrClient:MSSessionTypeClient];
  CCScene* scene = [CCNode node];
  [scene addChild:layer];
  CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5f scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
  [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void)onHelpButtonPressed:(id)sender {
}

@end
