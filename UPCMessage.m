//
//  UnityMessage.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 21/03/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "UPCMessage.h"

@implementation UPCMessage

@synthesize method;
@synthesize roomId;
@synthesize args;

- (id)init
{
  self = [super init];
  args = [[NSMutableArray alloc] init];
  return self;
}

- (id)initWithMethod:(NSString*)pMethod withRoomId:(NSString*)pRoomId
{
  self = [self init];
  method = pMethod;
  roomId = pRoomId;
  return self;
}

- (id)initWithMethod:(NSString*)pMethod withRoomId:(NSString*)pRoomId withArgs:firstArg, ...
{
  id ret = [self initWithMethod:pMethod withRoomId:pRoomId];
  
  va_list argsList;
  id eachArg;
  if (firstArg) {
    [args addObject:firstArg];
    va_start(argsList, firstArg);
    while (eachArg = va_arg(argsList, id)) {
      [args addObject:eachArg];
    }
    va_end(argsList);
  }
  
  return ret;
}

- (void)dealloc
{
  [args release];
  [super dealloc];
}

- (NSXMLDocument*)XMLDocument
{
  NSXMLElement* root = [[NSXMLElement alloc] initWithName:@"UPC"];
  NSXMLDocument* doc = [[NSXMLDocument alloc] initWithRootElement:root];
  
  NSXMLElement* elem = [[NSXMLElement alloc] initWithName:@"ROOMID" stringValue:[self roomId]];
  [root addChild:elem];
  
  elem = [[NSXMLElement alloc] initWithName:@"METH" stringValue:[self method]];
  [root addChild:elem];
  
  elem = [[NSXMLElement alloc] initWithName:@"ARGS"];
  [root addChild:elem];
  
  int i;
  NSXMLElement* argElem;
  /* @todo switch for fast iterator */
  for (i = 0; i < [[self args] count]; i++) {
    argElem = [[NSXMLElement alloc] initWithName:@"ARG" stringValue:[[self args] objectAtIndex:i]];
    [elem addChild:argElem];
  }
  
  return doc;
}

#pragma mark -

+ (id)fromXMLDocument:(NSXMLDocument*)pXML
{
  UPCMessage* message = [[UPCMessage alloc] autorelease];
  
  NSArray* nodes;
  
  NSXMLElement* methElement   = nil;
  NSXMLElement* roomIdElement = nil;
  NSXMLElement* argsElement   = nil;
  
  nodes = [[pXML rootElement] elementsForName:@"METH"];
  if ([nodes count] > 0) {
    methElement = [nodes lastObject];
    message.method = [methElement stringValue];
  }
  
  nodes = [[pXML rootElement] elementsForName:@"ROOMID"];
  if ([nodes count] > 0) {
    roomIdElement = [nodes lastObject];
    message.roomId = [roomIdElement stringValue];
  }
  
  message.args = [[NSMutableArray alloc] init];
  
  nodes = [[pXML rootElement] elementsForName:@"ARGS"];
  if ([nodes count] > 0) {
    argsElement = [nodes lastObject];
    
    nodes = [argsElement elementsForName:@"ARG"];
    
    int i;
    /* @todo switch for fast iterator */
    for (i = 0; i < [nodes count]; i++) {
      NSString* val = [[nodes objectAtIndex:i] stringValue];
      [message.args addObject:val];
    }
  }
  
  return message;
}

#pragma mark -

+ (id)createMessage:(NSString*)text
{
  return [[UPCMessage alloc] initWithMethod:@"displayMessage" withRoomId:@"unity" withArgs:text];
}

+ (id)createMessage:(NSString*)text toClient:(NSString*)clientId
{
  return nil;
}

+ (id)createAction:(NSString*)text
{
  return nil;
}

+ (id)createClientAttribute:(NSString*)value forKey:(NSString*)key
{
  return nil;
}

@end
