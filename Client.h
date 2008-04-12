//
//  Client.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 26/03/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Client : NSObject {
  NSString* clientId;
  NSMutableDictionary* attributes;
}

@property(readwrite, assign) NSString* clientId;
@property(readwrite, assign) NSMutableDictionary* attributes;

- (id)init;
- (id)initWithId:(NSString*)clientId;

- (NSString*)clentId;
- (NSString*)username;

- (NSString*)getAttribute:(NSString*)name;
- (void)setAttribute:(NSString*)name withValue:(NSString*)value;
- (BOOL)hasAttribute:(NSString*)name;
- (void)removeAttribute:(NSString*)name;

+ (Client*)fromId:(NSString*)clientId;
+ (Client*)fromId:(NSString*)pClentId andUnityAttributeString:(NSString*)pAttributes;

@end
