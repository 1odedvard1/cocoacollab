//
//  USimpleClientTests.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 16/04/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

#import "USimpleClient.h"

@interface USimpleClientTests : SenTestCase {
}

- (void)test_serializesUnknownMessage;

@end

#pragma mark -

@interface TestClient : USimpleClient {
  
}

- (void)localTestMethod;

@end