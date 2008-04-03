//
//  ClientListTests.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 30/03/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface ClientListTests : SenTestCase {

}

- (id)createClient:(NSString*)clientId;

- (void)test_add_and_get_client;
- (void)test_removeClient;

@end
