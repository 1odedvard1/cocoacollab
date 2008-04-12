//
//  Collab.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 06/04/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import "Collab.h"
#import "UPCMessage.h"
#import "NetSocket.h"
#import "XMLSocket.h"
#import "ClientList.h"
#import "Client.h"

@interface Collab (Private)
- (void)processIncomingXML:(NSXMLDocument*)pXML;
- (void)sendPublicMessage:(NSString*)pMessage;
@end

#pragma mark -

@implementation Collab

@synthesize delegate;
@synthesize clientId;
@synthesize clients;
@synthesize history;

- (id)init
{
  self = [super init];
  
  clients = [[ClientList alloc] init];
  [clients setDelegate:self];
  
  socket = [[XMLSocket alloc] init];
  [socket setDelegate:self];
  
  history = [[NSMutableArray alloc] init];
  
  return self;
}

- (void)dealloc
{
  [clients release];
  [socket release];
  [history release];
  [clientId release];
  
  [super dealloc];
}

#pragma mark -

- (NSString*)username
{
  return [[clients getClient:clientId] username];
}

#pragma mark -

- (IBAction)connect:(id)sender
{
  [socket open];
  [socket connectToHost:DEFAULT_HOST port:DEFAULT_PORT timeout:10];
  [socket scheduleOnCurrentRunLoop];
  
  /* @todo call delegate */
}

- (IBAction)disconnect:(id)sender
{
  [socket close];
  
  /* @todo call delegate */
}

- (void)sendRawMessage:(NSString*)method withRoomId:(NSString*)roomId withArgs:firstArg, ...
{
  va_list argsList;
  id eachArg;
  
  UPCMessage* message = [[UPCMessage alloc] initWithMethod:method withRoomId:roomId];
  
  if (firstArg) {
    [[message args] addObject:firstArg];
    
    va_start(argsList, firstArg);
    
    while (eachArg = va_arg(argsList, id)) {
      [[message args] addObject:eachArg];
    }
    
    va_end(argsList);
  }
  
  [socket sendXML:[message XMLDocument]];
  
  [message release];
}

- (void)sendMessage:(NSString*)pMessage
{
  [self sendRawMessage:@"invokeOnRoom" withRoomId:@"unity" withArgs:@"displayMessage", @"collab.global", @"false", pMessage, nil];
}

#pragma mark -

- (void)netsocketConnected:(NetSocket*)pSocket
{
}

- (void)netsocket:(NetSocket*)pSocket connectionTimedOut:(NSTimeInterval*)pTimeout
{
}

- (void)netsocketDisconnected:(NetSocket*)pSocket
{
}

- (void)xmlsocket:(XMLSocket*)pSocket xmlAvailable:(NSXMLDocument*)pXML
{
  UPCMessage* message = [UPCMessage fromXMLDocument:pXML];
  
  if (message) {
    NSString* selectorName = [[NSString alloc] initWithFormat:@"handle_%@:", [message method]];
    
    SEL selector = NSSelectorFromString(selectorName);
    
    if ([self respondsToSelector:selector]) {
      [self performSelector:selector withObject:message];
    }
    else {
      NSLog(@"WARNING: No handler for %@", [message method]);
    }
    
    [selectorName release];
  }
}

#pragma mark -

- (void)clientList:(ClientList*)clientList clientAdded:(Client*)client
{
}

- (void)clientList:(ClientList*)clientList clientRemoved:(Client*)client
{
}

#pragma mark -

- (void)handle_upcSetClientID:(UPCMessage*)pMessage
{
  if (clientId) {
    NSLog(@"WARNING: Client ID already set");
    return;
  }
  
  clientId = [[[pMessage args] objectAtIndex:0] copy];
  
  if (!clientId) {
    NSLog(@"WARNING: Server omitted client ID");
    return;
  }
  
  [clients addClient:[[[Client alloc] initWithId:clientId] retain]];
  
  NSLog(@"Client ID set: %@", clientId);
  
  /* @todo call delegate */
  
  [self sendRawMessage:@"joinRoom" withRoomId:@"unity" withArgs:@"global", @"collab", @"null", nil];
}

- (void)handle_upcOnClientAttributeUpdate:(UPCMessage*)pMessage
{
  NSString* cid = [[pMessage args] objectAtIndex:2];
  NSString* key = [[pMessage args] objectAtIndex:3];
  NSString* val = [[pMessage args] objectAtIndex:4];
  
  Client* client = [clients getClient:cid];
  if (client) {
    [client setAttribute:key withValue:val];
    
    /* @todo call delegate */
  }
  
  NSLog(@"%@: '%@' -> '%@'", cid, key, val);
}

- (void)handle_upcOnJoinRoom:(UPCMessage*)pMessage
{
  Client* client = [clients getClient:clientId];
  
  if (client) {
    NSString* msg = [NSString stringWithFormat:@"<b>%@ has joined.</b>", [client username]];
    [self sendRawMessage:@"invokeOnRoom" withRoomId:@"unity" withArgs:@"joinMessage", @"collab.global", @"false", msg, nil];
    
    /* @todo call delegate */
  }
}

- (void)handle_displayMessage:(UPCMessage*)pMessage
{
  NSString* cid = [[pMessage args] objectAtIndex:0];
  NSString* msg = [[pMessage args] objectAtIndex:1];
  
  Client* client = [clients getClient:cid];
  
  if (client) {
    /* @todo call delegate */
  }
}

- (void)handle_upcSetClientList:(UPCMessage*)pMessage
{
  int i;
  
  for (i = 2; i < [pMessage.args count] - 2; i += 3) {
    NSString* cid   = [pMessage.args objectAtIndex:i];
    
    if (![clientId isEqualToString:cid]) {
      NSString* attrs = [pMessage.args objectAtIndex:i+1];
      
      [clients addClient:[[Client fromId:cid andUnityAttributeString:attrs] retain]];
    }
  }
  
  /* @todo call delegate */
}

- (void)handle_meText:(UPCMessage*)pMessage
{
  NSString* cid = [[pMessage args] objectAtIndex:0];
  NSString* msg = [[pMessage args] objectAtIndex:1];
  
  Client* client = [clients getClient:cid];
  
  if (client) {
    /* @todo call delegate */
  }
}

- (void)handle_joinMessage:(UPCMessage*)pMessage
{
  NSString* msg = [[pMessage args] objectAtIndex:1];
}

- (void)handle_upcOnRemoveClient:(UPCMessage*)pMessage
{
  NSString* cid = [[pMessage args] objectAtIndex:2];
  
  Client* client = [clients getClient:cid];
  
  if (client) {
    /* @todo call delegate */
  }
  
  [clients removeClient:cid];
}

- (void)handle_upcOnAddClient:(UPCMessage*)pMessage
{
  NSString* cid  = [[pMessage args] objectAtIndex:2];
  NSString* args = [[pMessage args] objectAtIndex:3];
  
  [clients addClient:[Client fromId:cid andUnityAttributeString:args]];
  
  /* @todo call delegate */
}

@end
