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
    self.mainMenu = menu;
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
  CCDirector* director = [CCDirector sharedDirector];
  MSMatchLayer* layer = [[MSMatchLayer alloc] initWithServerOrClient:MSSessionTypeServer];
  [self addChild:layer];
  layer.position = ccp(0, director.screenSize.height * 1.5);
  [layer runAction:[CCMoveTo actionWithDuration:0.5f position:CGPointZero]];
  [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
  [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"matching.caf"];
  self.mainMenu.enabled = NO;
}

/**
 Clientボタンが押されたとき
 */
- (void)onClientButtonPressed:(id)sender {
  CCDirector* director = [CCDirector sharedDirector];
  MSMatchLayer* layer = [[MSMatchLayer alloc] initWithServerOrClient:MSSessionTypeClient];
  [self addChild:layer];
  layer.position = ccp(0, director.screenSize.height * 1.5);
  [layer runAction:[CCMoveTo actionWithDuration:0.5f position:CGPointZero]];
  [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
  [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"matching.caf"];
  self.mainMenu.enabled = NO;
}

- (void)onHelpButtonPressed:(id)sender {
}

@end
