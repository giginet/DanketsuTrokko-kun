//
//  MSAngel.h
//  MultipleSession
//
//  Created by giginet on 2013/1/23.
//
//

#import <Foundation/Foundation.h>

@interface MSAngel : NSObject {
  NSString* _peerID;
}

@property(readonly, copy) NSString* peerID;

- (id)initWithPeerID:(NSString*)peerID;

@end
