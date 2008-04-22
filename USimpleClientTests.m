//
//  USimpleClientTests.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 16/04/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import "USimpleClientTests.h"

@implementation USimpleClientTests

- (void)test_serializesUnknownMessage
{
  USimpleClient* client = [[USimpleClient alloc] init];
  
  [client release];
}

@end
