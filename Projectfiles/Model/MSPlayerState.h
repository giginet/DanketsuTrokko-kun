//
//  MSPlayerState.h
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import <Foundation/Foundation.h>

@interface MSPlayerState : NSObject <NSCoding> {
}

@property(readwrite) CGPoint position;

+ (MSPlayerState*)stateWithData:(NSData*)data;

@end
