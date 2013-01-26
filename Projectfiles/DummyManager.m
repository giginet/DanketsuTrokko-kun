//
//  DummyManager.m
//  MultipleSession
//
//  Created by 能登 要 on 13/01/26.
//
//

#import "DummyManager.h"

static NSString* s_serverID = @"server";
static NSString* s_playerID = @"player";
static NSString* s_player2ID = @"player2";
static NSString* s_player3ID = @"player3";

@implementation DummyManager

+ (NSString*) serverID
{
    return s_serverID;
}

+ (NSString*) playerID
{
    return s_playerID;
}

+ (NSString*) player2ID
{
    return s_player2ID;
}

+ (NSString*) player3ID
{
    return s_player3ID;
}



@end
