//
//  Collab.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 06/04/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define DEFAULT_HOST @"unity.collab.nl"
#define DEFAULT_PORT 9110

@class Client;
@class ClientList;
@class XMLSocket;
@class UPCMessage;

@interface Collab : NSObject {
  id delegate;
  NSString* clientId;
  ClientList* clients;
  NSMutableArray* history;
  XMLSocket* socket;
}

@property(readwrite, assign) id delegate;

@property(readonly) NSString* clientId;
@property(readonly) ClientList* clients;
@property(readonly) NSArray* history;

@end

#pragma mark -

@interface Collab (API)
- (NSString*)username;

- (void)connect;
- (void)connectAndSetAttributes:(NSDictionary*)attributes;
- (void)disconnect;

- (void)sendRawMessage:(NSString*)method withRoomId:(NSString*)roomId withArgs:firstArg, ...;

- (void)sendMessage:(NSString*)message;
//- (void)sendMessage:(NSString*)message toClient:(Client*)client;
//- (void)sendAction:(NSString*)message;

- (void)setAttribute:(NSString*)name withValue:(NSString*)value;
- (void)getAttribute:(NSString*)name;
@end

#pragma mark -
                     
@interface Collab (ProtocolHandler)
- (void)handle_upcSetClientID:(UPCMessage*)message;
- (void)handle_upcOnClientAttributeUpdate:(UPCMessage*)pMessage;
- (void)handle_upcOnJoinRoom:(UPCMessage*)pMessage;
- (void)handle_displayMessage:(UPCMessage*)pMessage;
- (void)handle_upcSetClientList:(UPCMessage*)pMessage;
- (void)handle_meText:(UPCMessage*)pMessage;
- (void)handle_joinMessage:(UPCMessage*)pMessage;
- (void)handle_upcOnRemoveClient:(UPCMessage*)pMessage;
- (void)handle_upcOnAddClient:(UPCMessage*)pMessage;
@end

#pragma mark -

@interface NSObject (CollabDelegate)
- (void)collabConnected:(Collab*)collab;
- (void)collabDisconnected:(Collab*)collab;

- (void)collab:(Collab*)collab messageReceived:(UPCMessage*)pMessage;

- (void)collab:(Collab*)collab clientAdded:(Client*)client;
- (void)collab:(Collab*)collab clientRemoved:(Client*)client;
- (void)collab:(Collab*)collab clientUpdated:(Client*)client;
@end