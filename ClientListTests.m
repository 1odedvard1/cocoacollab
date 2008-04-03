//
//  ClientListTests.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 30/03/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ClientListTests.h"

#import "Client.h"
#import "ClientList.h"

@implementation ClientListTests

- (id)createClient:(NSString*)clientId
{
  return [[Client alloc] initWithId:clientId];
}

- (void)test_add_and_get_client
{
  ClientList* list = [[ClientList alloc] init];
  
  [list addClient:[self createClient:@"TEST_ID"]];
  
  Client* client = [list getClient:@"TEST_ID"];
  STAssertTrue([@"TEST_ID" isEqualToString:[client clientId]], [client clientId]);
  
  [client release];
}

- (void)test_removeClient
{
  ClientList* list = [[ClientList alloc] init];
  
  [list addClient:[self createClient:@"TEST_ID"]];
  STAssertNotNil([list getClient:@"TEST_ID"], @"Client should not be nil!");
  
  [list removeClient:@"TEST_ID"];
  STAssertNil([list getClient:@"TEST_ID"], @"Client should be nil!");
}

@end
