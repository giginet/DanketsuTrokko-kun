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
    
    CCSprite* sky = [CCSprite spriteWithFile:@"sky.png"];
    sky.position = director.screenCenter;
    [self addChild:sky];
    CCNode* background = [CCNode node];
    for (int i = 0; i < 20; ++i ) {
      CCSprite* grass = [CCSprite spriteWithFile:@"grass.jpg"];
      float center = director.screenCenter.x;
      CGPoint initial = ccp(center, grass.contentSize.height * i);
      grass.position = initial;
      [grass runAction:[CCRepeatForever actionWithAction:[CCSequence actions:
                                                               [CCMoveBy actionWithDuration:1.0 position:ccp(0, -2 * grass.contentSize.height)],
                                                               [CCPlace actionWithPosition:initial],
                                                               nil]]];
      [background addChild:grass];
      
    }
    [self addChild:background];
    float centerX, centerY, centerZ;
    float eyeX, eyeY, eyeZ;
    [background.camera centerX:&centerX centerY:&centerY centerZ:&centerZ];
    [background.camera setCenterX:centerX centerY:centerY + 0.000001 centerZ:centerZ];
    [background.camera eyeX:&eyeX  eyeY:&eyeY eyeZ:&eyeZ];
    [background.camera setEyeX:eyeX eyeY:eyeY eyeZ:eyeZ + 0.00000001];
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
