//
//  XMLSocketTests.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 31/03/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import "XMLSocketTests.h"
#import "NetSocket.h"
#import "XMLSocket.h"
#import "NullTerminatedTokenBuffer.h"

#import <OCMock/OCMock.h>

@implementation XMLSocketTests

- (void)setUp
{
  //mock = [OCMockObject mockForClass:[XMLSocket class]];
}

#define TEST_SEND_XML @"<TEST_XML>TEST_VALUE</TEST_XML>"

- (void)test_sendXML
{
  //NSError* err       = [[NSError alloc] init];
  //NSXMLDocument* xml = [[NSXMLDocument alloc] initWithXMLString:TEST_SEND_XML options:0 error:&err];
  //[err release];
  
  //[[mock stub] writeString:OCMOCK_ANY encoding:NSUTF8StringEncoding];
  //[[mock stub] sendXML:OCMOCK_ANY];
  
  //[[mock expect] sendXML:xml];
  //[[mock expect] writeString:[[xml XMLString] stringByAppendingString:NULL_TERMINATOR] encoding:NSUTF8StringEncoding];
  
  //[mock sendXML:xml];
  
  //[mock verify];
  
  //[xml release];
}

- (void)test_receiveXML
{
  
}

@end
