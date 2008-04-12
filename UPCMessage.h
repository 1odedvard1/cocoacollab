//
//  CollabMessage.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 21/03/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define ON_SET_CLIENT_ID           @"upcSetClientID"
#define ON_CLIENT_ATTRIBUTE_UPDATE @"upcOnClientAttributeUpdate"
#define ON_JOIN_ROOM               @"upcOnJoinRoom"
#define ON_DISPLAY_MESSAGE         @"displayMessage"
#define ON_SET_CLIENT_LIST         @"upcSetClientList"
#define ON_ME_TEXT                 @"meText"
#define ON_JOIN_MESSAGE            @"joinMessage"
#define ON_REMOVE_CLIENT           @"upcOnRemoveClient"
#define ON_ADD_CLIENT              @"upcOnAddClient"

@interface UPCMessage : NSObject {
  NSString* method;
  NSString* roomId;
  NSMutableArray*  args;
}

@property(readwrite, copy) NSString* method;
@property(readwrite, copy) NSString* roomId;
@property(readwrite, assign) NSMutableArray* args;

- (id)initWithMethod:(NSString*)pMethod withRoomId:(NSString*)pRoomId;
- (id)initWithMethod:(NSString*)pMethod withRoomId:(NSString*)pRoomId withArgs:firstArg, ...;

- (NSXMLDocument*)XMLDocument;

+ (id)fromXMLDocument:(NSXMLDocument*)pXML;

@end
