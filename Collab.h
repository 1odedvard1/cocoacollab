//
//  Collab.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 06/04/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Client;
@class ClientList;

@interface Collab : NSObject {
  NSString* clientId;
  ClientList* clients;
  NSMutableArray* history;
}

@property(readonly) NSString* clientId;
@property(readonly) ClientList* clients;
@property(readonly) NSArray* history;

@end

@interface Collab (API)
- (void)connect;
- (void)connectAndSetAttributes:(NSDictionary*)attributes;
- (void)disconnect;

- (void)sendMessage:(NSString*)message;
- (void)sendMessage:(NSString*)message toClient:(Client*)client;
- (void)sendAction:(NSString*)message;

- (void)setAttribute:(NSString*)name withValue:(NSString*)value;
- (void)getAttribute:(NSString*)name;
@end
                     
@interface NSObject (CollabDelegate)
- (void)collabConnected:(Collab*)collab;
- (void)collabDisconnected:(Collab*)collab;

- (void)collab:(Collab*)collab messageReceived:(NSString*)message fromClient:(Client*)client;

- (void)collab:(Collab*)collab clientAdded:(Client*)client;
- (void)collab:(Collab*)collab clientRemoved:(Client*)client;
- (void)collab:(Collab*)collab clientUpdated:(Client*)client;
@end