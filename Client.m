//
//  Client.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 26/03/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Client.h"


@implementation Client

@synthesize clientId;
@synthesize attributes;

- (id)init
{
  self = [super init];
  attributes = [[NSMutableDictionary alloc] init];
  return self;
}

- (id)initWithId:(NSString*)pId
{
  self = [self init];
  NSLog(@"New client created with ID '%@'", pId);
  clientId = [pId copy];
  return self;
}

- (void)release
{
  [clientId release];
  [attributes release];
}

- (NSString*)getAttribute:(NSString*)name
{
  return [attributes valueForKey:name];
}

- (BOOL)hasAttribute:(NSString*)name
{
  return ([attributes valueForKey:name]) ? YES : NO;
}

- (void)setAttribute:(NSString*)name withValue:(NSString*)value
{
  [attributes setValue:value forKey:name];
}

- (void)removeAttribute:(NSString*)name
{
  [attributes removeObjectForKey:name];
}

+ (Client*)fromId:(NSString*)clientId
{
  return [[Client alloc] initWithId:clientId];
}

+ (Client*)fromId:(NSString*)clientId andUnityAttributeString:(NSString*)attributes
{
  Client* ret = [[Client alloc] initWithId:clientId];
  
  // trivia=true|rank=guest|_IP=84.142.235.63|username=Eaza|location=collab|_CONNECTTIME=1206568705423
  
  NSArray* parts = [attributes componentsSeparatedByString:@"|"];
  int i;
  for (i = 0; i < [parts count]; i++) {
    NSString* part = [parts objectAtIndex:i];
    if ([part length] > 0) {
      NSArray* keyval = [part componentsSeparatedByString:@"="];
      if ([keyval count] == 2) {
        [ret setAttribute:[keyval objectAtIndex:0] withValue:[keyval objectAtIndex:1]];
      }
      else {
        NSAssert(@"Unbalanced key pairs: '%@'", part);
      }
    }
  }
  
  return ret;
}

@end
