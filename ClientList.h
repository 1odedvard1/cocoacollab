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
  
  NSMutableArray* clients;
  
}

@property(readonly) NSDictionary* clients;

- (id)init;

- (Client*)getClient:(NSString*)clientId;
- (void)addClient:(Client*)client;
- (void)removeClient:(NSString*)clientId;

@end
