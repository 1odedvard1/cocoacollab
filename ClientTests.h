//
//  ClientTests.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 30/03/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@interface ClientTests : SenTestCase {

}

- (void)test_initWithId;
- (void)test_set_and_get_attributes;
- (void)test_remove_attribute;

- (void)test_fromId;
- (void)test_fromId_andUnityAttributeString;

@end
