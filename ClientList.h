//
//  ClientList.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 26/03/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
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
- (void)addClient:(Client*)client;
- (void)removeClient:(NSString*)clientId;

@end

#pragma mark -

@interface NSObject (ClientListDelegate)
- (void)clientlist:(ClientList*)clientList clientAdded:(Client*)client;
- (void)clientList:(ClientList*)clientList clientRemoved:(Client*)client;
@end