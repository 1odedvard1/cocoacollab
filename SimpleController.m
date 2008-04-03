//
//  SimpleController.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 31/03/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import "SimpleController.h"
#import "NetSocket.h"
#import "XMLSocket.h"
#import "UPCMessage.h"
#import "Client.h"
#import "ClientList.h"

@interface SimpleController (Private)
- (void)processIncomingXML:(NSXMLDocument*)pXML;
@end

@interface SimpleController (ClientListDelegate)
- (void)clientList:(ClientList*)clientList clientAdded:(Client*)client;
- (void)clientList:(ClientList*)clientList clientRemoved:(Client*)client;
@end

@interface SimpleController (ProtocolHandler)
- (void)handle_upcSetClientID:(UPCMessage*)message;
- (void)handle_upcOnClientAttributeUpdate:(UPCMessage*)pMessage;
@end

@implementation SimpleController

- (id)init
{
  self = [super init];
  
  clients = [[ClientList alloc] init];
  [clients setDelegate:self];
  
  socket = [[XMLSocket alloc] init];
  [socket setDelegate:self];
  
  return self;
}

- (void)awakeFromNib
{
  [self connect:nil];
}

- (void)dealloc
{
  [clients release];
  [socket release];
  [super dealloc];
}

#pragma mark -

- (IBAction)connect:(id)sender
{
  [socket open];
  [socket connectToHost:DEFAULT_HOST port:DEFAULT_PORT];
  [socket scheduleOnCurrentRunLoop];
  [self appendOutputText:@"Connecting.."];
}

- (IBAction)disconnect:(id)sender
{
  [self appendOutputText:@"Disconnecting.."];
  [socket close];
}

- (IBAction)processInput:(id)sender
{
  NSLog(@"processInput");
}

#pragma mark -

- (void)netsocketConnected:(NetSocket*)pSocket
{
  [self appendOutputText:@"Connected."];
}

- (void)netsocket:(NetSocket*)pSocket connectionTimedOut:(NSTimeInterval*)pTimeout
{
  [self appendOutputText:@"Timed out."];
}

- (void)netsocketDisconnected:(NetSocket*)pSocket
{
  [self appendOutputText:@"Disconnected."];
}

- (void)xmlsocket:(XMLSocket*)pSocket xmlAvailable:(NSXMLDocument*)pXML
{
  //NSLog(@"IN: %@", [pXML XMLString]);
  [self processIncomingXML:pXML];
}

#pragma mark -

- (int)numberOfRowsInTableView:(NSTableView*)pTableView
{
  return [[clients clients] count];
}

- (id)tableView:(NSTableView*)pTableView objectValueForTableColumn:(NSTableColumn*)pTableColumn row:(int)pRow
{
  Client* client = [[clients clients] objectAtIndex:pRow];
  
  if (client) {
    if ([client hasAttribute:@"username"]) {
      return [client getAttribute:@"username"];
    }
    else {
      return [NSString stringWithFormat:@"Guest%@", [client clientId]];
    }
  }
  
  return nil;
}

#pragma mark -

- (void)appendOutputText:(NSString*)text
{
  NSRange endRange;
  endRange.location = [[outputText textStorage] length];
  endRange.length   = 0;
  
  NSString* output = [text stringByAppendingString:@"\n"];
  
  [outputText replaceCharactersInRange:endRange withString:output];
  [outputText scrollRangeToVisible:endRange];
}

#pragma mark -

- (void)processIncomingXML:(NSXMLDocument*)pXML
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
  [usersTable reloadData];
}

- (void)clientList:(ClientList*)clientList clientRemoved:(Client*)client
{
  [usersTable reloadData];
}

#pragma mark -

- (void)handle_upcSetClientID:(UPCMessage*)pMessage
{
  if (clientId) {
    NSLog(@"WARNING: Client ID already set");
    return;
  }
  
  clientId = [[pMessage args] objectAtIndex:0];
  
  if (!clientId) {
    NSLog(@"WARNING: Server omitted client ID");
    return;
  }
  
  [clients addClient:[[Client alloc] initWithId:clientId]];
  
  NSLog(@"Client ID set: %@", clientId);
}

- (void)handle_upcOnClientAttributeUpdate:(UPCMessage*)pMessage
{
  NSString* cid = [[pMessage args] objectAtIndex:2];
  NSString* key = [[pMessage args] objectAtIndex:3];
  NSString* val = [[pMessage args] objectAtIndex:4];
  
  Client* client = [clients getClient:cid];
  if (client) {
    [client setAttribute:key withValue:val];
  }
  
  NSLog(@"%@: '%@' -> '%@'", cid, key, val);
}

@end
