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
}

- (void)onHelpButtonPressed:(id)sender
{
  if( _spriteHelp == nil ){
    _spriteHelp = [CCSprite spriteWithFile:@"GGJ2013_team1_help1.png"];
    CCDirector* director = [CCDirector sharedDirector];
    _spriteHelp.position = director.screenCenter;
    [self addChild:_spriteHelp];
  }else{
    [_spriteHelp setTexture:[[CCTextureCache sharedTextureCache] addImage:@"GGJ2013_team1_help1.png"] ];
  }
  
  _helpIndex  = 0;
  [KKInput sharedInput].gestureTapEnabled = YES;
}

- (void)update:(ccTime)dt {
  KKInput* input = [KKInput sharedInput];
  if( input.gestureTapRecognizedThisFrame ){
    _helpIndex++;
    
    NSArray* helpFiles =  @[@"GGJ2013_team1_help1.png",@"GGJ2013_team1_help1.png",@"GGJ2013_team1_help2.png",@"GGJ2013_team1_help3.png",@"GGJ2013_team1_help4.png",@"GGJ2013_team1_help5.png",@"GGJ2013_team1_help6.png"];
    
    if( [helpFiles count] < _helpIndex ){
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
