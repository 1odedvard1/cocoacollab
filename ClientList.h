//
//  ClientList.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 26/03/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Client;

@interface ClientList : NSObject {
  id delegate;
  NSMutableArray* clients;
}

@property(readwrite, assign) id delegate;
@property(readonly) NSMutableArray* clients;

- (id)init;

- (Client*)getClient:(NSString*)clientId;
- (Client*)getClientByAttribute:(NSString*)key withValue:(NSString*)value;
- (Client*)getClientByUsername:(NSString*)username;
- (void)addClient:(Client*)client;
- (void)removeClient:(NSString*)clientId;
- (void)clear;

@end

#pragma mark -

@interface NSObject (ClientListDelegate)
- (void)clientList:(ClientList*)clientList clientAdded:(Client*)client;
- (void)clientList:(ClientList*)clientList clientRemoved:(Client*)client;
@end