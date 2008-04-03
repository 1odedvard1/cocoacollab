//
//  XMLSocketTests.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 31/03/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface XMLSocketTests : SenTestCase {
  id mock;
}

- (void)test_sendXML;
- (void)test_receiveXML;

@end
