//
//  ClientTests.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 30/03/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ClientTests.h"

#import "Client.h"

@implementation ClientTests

- (void)test_initWithId
{
  Client* client = [[Client alloc] initWithId:@"TEST_ID"];
  
  STAssertTrue([@"TEST_ID" isEqualToString:[client clientId]], [client clientId]);
  
  [client release];
}

- (void)test_set_and_get_attributes
{
  Client* client = [[Client alloc] initWithId:@"TEST_ID"];
  [client setAttribute:@"TEST_ATTRIBUTE" withValue:@"TEST_VALUE"];
  
  NSString* value = [client getAttribute:@"TEST_ATTRIBUTE"];
  STAssertTrue([@"TEST_VALUE" isEqualToString:value], @"Value is '%@'", value);
  
  [client release];
}

- (void)test_remove_attribute
{
  Client* client = [[Client alloc] initWithId:@"TEST_ID"];
  [client setAttribute:@"TEST_ATTRIBUTE" withValue:@"TEST_VALUE"];
  
  NSString* value = [client getAttribute:@"TEST_ATTRIBUTE"];
  STAssertNotNil(value, @"Property TEST_VALUE should not be nil!");
  
  [client removeAttribute:@"TEST_ATTRIBUTE"];
  value = [client getAttribute:@"TEST_ATTRIBUTE"];
  STAssertNil(value, @"Property TEST_VALUE should be nil!");
  
  [client release];
}

- (void)test_fromId
{
  Client* client = [Client fromId:@"TEST_ID"];
  
  STAssertTrue([@"TEST_ID" isEqualToString:[client clientId]], [client clientId]);
  
  [client release];
}

- (void)test_fromId_andUnityAttributeString
{
  Client* client = [Client fromId:@"TEST_ID" andUnityAttributeString:@"TEST_ATTR1=TEST_VAL1|TEST_ATTR2=TEST_VAL2"];
  
  STAssertTrue([@"TEST_ID" isEqualToString:[client clientId]], [client clientId]);
  
  NSString* value = [client getAttribute:@"TEST_ATTR1"];
  STAssertTrue([@"TEST_VAL1" isEqualToString:value], @"Value is '%@'", value);
  
  value = [client getAttribute:@"TEST_ATTR2"];
  STAssertTrue([@"TEST_VAL2" isEqualToString:value], @"Value is '%@'", value);
  
  [client release];
}

@end
