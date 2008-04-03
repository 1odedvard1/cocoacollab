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

@synthesize clients;

- (id)init
{
  id ret = [super init];
  clients = [[NSMutableDictionary alloc] init];
  return ret;
}

- (void)release
{
  [super release];
  [clients release];
}

- (Client*)getClient:(NSString*)clientId
{
  return [clients valueForKey:clientId];
}

- (void)addClient:(Client*)client
{
  [clients setValue:client forKey:[client clientId]];
}

- (void)removeClient:(NSString*)clientId
{
  [clients removeObjectForKey:clientId];
}

@end
