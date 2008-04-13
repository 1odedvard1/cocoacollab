//
//  ClientList.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 26/03/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ClientList.h"
#import "Client.h"

@implementation ClientList

@synthesize delegate;
@synthesize clients;

- (id)init
{
  id ret = [super init];
  clients = [[NSMutableArray alloc] init];
  return ret;
}

- (void)release
{
  [super release];
  [clients release];
}

#pragma mark -

- (Client*)getClient:(NSString*)clientId
{
  Client* client;
  for (client in clients) {
    if ([clientId isEqualToString:[client clientId]]) {
      return client;
    }
  }
  return nil;
}

- (Client*)getClientByAttribute:(NSString*)key withValue:(NSString*)value
{
  Client* client;
  for (client in clients) {
    NSEnumerator* keys = [[client attributes] keyEnumerator];
    NSString* fkey;
    
    while ((fkey = [keys nextObject]) != nil) {
      if ([key isEqualToString:fkey] && [value isEqualToString:[client getAttribute:fkey]]) {
        return client;
      }
    }
  }
  return nil;
}

- (Client*)getClientByUsername:(NSString*)username
{
  Client* client;
  for (client in clients) {
    if ([username isEqualToString:[client username]]) {
      return client;
    }
  }
  return nil;
}

#pragma mark -

- (void)addClient:(Client*)client
{
  [clients addObject:client];
  
  if ([delegate respondsToSelector:@selector(clientList:clientAdded:)]) {
    [delegate clientList:self clientAdded:client];
  }
}

- (void)removeClient:(NSString*)clientId
{
  Client* client = [self getClient:clientId];
  
  if (client) {
    [clients removeObject:client];
    //[client release]; - double free?!
  }
  
  if ([delegate respondsToSelector:@selector(clientList:clientRemoved:)]) {
    [delegate clientList:self clientRemoved:client];
  }
}

@end
