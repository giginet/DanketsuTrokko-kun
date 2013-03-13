//
//  MSTitleLayer.m
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import "MSTitleLayer.h"
#import "MSMatchLayer.h"
#import "KKInput.h"
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
    
    // CCSchedulerにこのインスタンスを登録する
    [self scheduleUpdate];
    self.mainMenu = menu;
    
  }
  return self;
}

- (void)onEnterTransitionDidFinish {
  [super onEnterTransitionDidFinish];
  [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"title.caf"];
}

- (void)onServerButtonPressed:(id)sender {
  CCDirector* director = [CCDirector sharedDirector];
  MSMatchLayer* layer = [[MSMatchLayer alloc] initWithServerOrClient:MSSessionTypeServer];
  layer.position = ccp(0, director.screenSize.height * 1.5);
  [self addChild:layer];
  [layer runAction:[CCMoveTo actionWithDuration:0.5f
                                       position:CGPointZero]];
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
  [layer runAction:[CCMoveTo actionWithDuration:0.5f
                                       position:CGPointZero]];
  self.mainMenu.enabled = NO;
}

- (void)onHelpButtonPressed:(id)sender
{
  if( _spriteHelp == nil ){
    _spriteHelp = [CCSprite spriteWithFile:@"GGJ2013_team1_help1.png"];
    CCDirector* director = [CCDirector sharedDirector];
    _spriteHelp.position = director.screenCenter;
    [self addChild:_spriteHelp];
  }
  
  [KKInput sharedInput].gestureTapEnabled = YES;
}

- (void)update:(ccTime)dt {
  KKInput* input = [KKInput sharedInput];
  if( input.gestureTapRecognizedThisFrame ){
    _helpIndex++;
    
    NSArray* helpFiles =  @[@"GGJ2013_team1_help1.png",@"GGJ2013_team1_help1.png",@"GGJ2013_team1_help2.png",@"GGJ2013_team1_help3.png",@"GGJ2013_team1_help4.png",@"GGJ2013_team1_help5.png",@"GGJ2013_team1_help6.png"];
    
    if( _helpIndex < [helpFiles count] ){
      NSString* fileFile = helpFiles[_helpIndex];
      [_spriteHelp setTexture:[[CCTextureCache sharedTextureCache] addImage:fileFile] ];
    }else{
      [self removeChild:_spriteHelp cleanup:YES];
      _spriteHelp = nil;
      
      [CCTextureCache purgeSharedTextureCache];
      
      [KKInput sharedInput].gestureTapEnabled = NO;
    }
  }
}


@end
