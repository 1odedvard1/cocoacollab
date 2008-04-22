//
//  USimpleClient.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 16/04/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define COLLAB_HOST @"unity.collab.nl"
#define COLLAB_PORT 9110

@class XMLSocket;

@interface USimpleClient : NSObject {
  XMLSocket* socket;
}

@property(readonly) XMLSocket* socket;
- (void)connect;
- (void)disconnect;
- (void)invokeMethod:(NSString*)pName ns:(NSString*)pNamespace roomId:(NSString*)pRoomId;
@end
