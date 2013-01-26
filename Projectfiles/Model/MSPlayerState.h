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

@property(readwrite) float scale;
@property(readwrite) float rotation;
@property(readwrite) CGPoint position;
@property(readwrite, copy) NSString* peerID;

+ (MSPlayerState*)stateWithData:(NSData*)data;

@end
