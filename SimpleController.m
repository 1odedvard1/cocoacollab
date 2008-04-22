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
#import "OutputRenderer.h"
#import "NSStringExtensions.h"

#import <WebKit/WebView.h>
#import <WebKit/WebFrame.h>
#import <WebKit/DOMExtensions.h>

@interface SimpleController (Private)
- (void)processIncomingXML:(NSXMLDocument*)pXML;
- (void)sendPublicMessage:(NSString*)pMessage;
- (void)sendAction:(NSString*)pMessage;
- (void)sendAttributeUpdate:(NSString*)value forKey:(NSString*)key;
@end

#pragma mark -

@interface SimpleController (ClientListDelegate)
- (void)clientList:(ClientList*)clientList clientAdded:(Client*)client;
- (void)clientList:(ClientList*)clientList clientRemoved:(Client*)client;
@end

@interface SimpleController (ProtocolHandler)
- (void)handle_upcSetClientID:(UPCMessage*)message;
- (void)handle_upcOnClientAttributeUpdate:(UPCMessage*)pMessage;
- (void)handle_upcOnJoinRoom:(UPCMessage*)pMessage;
- (void)handle_displayMessage:(UPCMessage*)pMessage;
- (void)handle_upcSetClientList:(UPCMessage*)pMessage;
- (void)handle_meText:(UPCMessage*)pMessage;
- (void)handle_joinMessage:(UPCMessage*)pMessage;
- (void)handle_upcOnRemoveClient:(UPCMessage*)pMessage;
- (void)handle_upcOnAddClient:(UPCMessage*)pMessage;
- (void)handle_receiveBotMsg:(UPCMessage*)pMessage;
@end

@implementation SimpleController

@synthesize clientId;

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
  NSBundle* bundle = [NSBundle bundleForClass:[self class]];
  
  NSString* path = [bundle pathForResource:@"CocoaCollab" ofType:@"png"];
  menuIcon = [[NSImage alloc] initWithContentsOfFile:path];
  
  statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
  [statusItem setToolTip:@"CocoaCollab!"];
  [statusItem setImage:menuIcon];
  //[statusItem setAction:@selector(toggleWindowVisibility:)];
  
  [[self window] makeKeyAndOrderFront:nil];
  
  [outputRenderer clear];
}

- (void)dealloc
{
  [clients release];
  [socket release];
  [clientId release];
  [menuIcon release];
  [super dealloc];
}

#pragma mark -

- (IBAction)connect:(id)sender
{
  [socket open];
  [socket connectToHost:DEFAULT_HOST port:DEFAULT_PORT timeout:10];
  [socket scheduleOnCurrentRunLoop];
  [outputRenderer renderInfoMessage:@"Connecting.."];
}

- (IBAction)disconnect:(id)sender
{
  [outputRenderer renderInfoMessage:@"Disconnecting.."];
  [socket close];
}

- (IBAction)processInput:(id)sender
{
  NSLog(@"processInput");
  
  NSString* input   = [sender stringValue];
  NSString* command = nil;
  NSString* args    = nil;
  
  if ([@"/" isEqualToString:[input substringWithRange:NSMakeRange(0, 1)]]) {
    NSRange delim = [input rangeOfString:@" "];
    int len = (delim.location == NSNotFound) ? ([input length] - 1) : (delim.location - 1);
    
    command = [input substringWithRange:NSMakeRange(1, len)];
    
    if ([input length] > [command length] + 2) {
      args = [NSString trim:[input substringWithRange:NSMakeRange(len + 1, [input length] - (len + 1))]];
    }
    
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"command_%@:", command]);
    if ([self respondsToSelector:selector]) {
      [self performSelector:selector withObject:args];
    }
    else {
      [outputRenderer renderInfoMessage:[NSString stringWithFormat:@"Invalid command '%@'", command]];
    }
  }
  else {
    [self sendPublicMessage:input];

    Client* client = [clients getClient:clientId];
    if (client) {
      [outputRenderer renderPublicMessage:input sender:client];
    }
  }
  
  [[self window] makeFirstResponder:inputText];
  [inputText setStringValue:@""];
}

- (IBAction)toggleWindowVisibility:(id)sender
{
  if ([[self window] isVisible]) {
    [[self window] orderOut:nil];
  }
  else {
    [[self window] makeKeyAndOrderFront:nil];
  }
}

- (IBAction)clearOutput:(id)sender
{
  [outputRenderer clear];
}

- (IBAction)launchWiki:(id)sender
{
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://github.com/cliffrowley/cocoacollab/wikis/"]];
}

#pragma mark -

- (void)netsocketConnected:(NetSocket*)pSocket
{
  [outputRenderer renderInfoMessage:@"Connected."];
}

- (void)netsocket:(NetSocket*)pSocket connectionTimedOut:(NSTimeInterval*)pTimeout
{
  [outputRenderer renderInfoMessage:@"Timed out."];
}

- (void)netsocketDisconnected:(NetSocket*)pSocket
{
  [outputRenderer renderInfoMessage:@"Disconnected."];
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
  return [[[clients clients] objectAtIndex:pRow] username];
}

#pragma mark -

- (void)sendPublicMessage:(NSString*)pMessage
{
  UPCMessage* message = [[UPCMessage alloc] initWithMethod:@"invokeOnRoom" withRoomId:@"unity" withArgs:@"displayMessage", @"collab.global", @"false", pMessage, nil];
  [socket sendXML:[message XMLDocument]];
  [message release];
}

- (void)sendAction:(NSString*)pMessage
{
  UPCMessage* message = [[UPCMessage alloc] initWithMethod:@"invokeOnNamespace" withRoomId:@"unity" withArgs:@"meText", @"collab", @"true", pMessage, nil];
  [socket sendXML:[message XMLDocument]];
  [message release];
}

- (void)sendAttributeUpdate:(NSString*)value forKey:(NSString*)key
{
  UPCMessage* message = [[UPCMessage alloc] initWithMethod:@"upcSetClientAttribute" withRoomId:@"unity" withArgs:key, value, @"null", @"true", @"false", @"false", nil];
  [socket sendXML:[message XMLDocument]];
  [message release];
  
  Client* client = [clients getClient:clientId];
  if (client) {
    [client setAttribute:key withValue:value];
    [usersTable reloadData];
  }
}

#pragma mark -

- (void)processIncomingXML:(NSXMLDocument*)pXML
{
  UPCMessage* message = [UPCMessage fromXMLDocument:pXML];
  if (message) {
    NSString* selectorName = [NSString stringWithFormat:@"handle_%@:", [message method]];
    SEL selector = NSSelectorFromString(selectorName);
    if ([self respondsToSelector:selector]) {
      [self performSelector:selector withObject:message];
    }
    else {
      NSLog(@"WARNING: No handler for %@", [message method]);
    }
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
  
  clientId = [[[pMessage args] objectAtIndex:0] copy];
  
  if (!clientId) {
    NSLog(@"WARNING: Server omitted client ID");
    return;
  }
  
  [clients addClient:[[Client alloc] initWithId:clientId]];
  
  NSLog(@"Client ID set: %@", clientId);
  
  UPCMessage* joinMessage =
    [[UPCMessage alloc] initWithMethod:@"joinRoom" withRoomId:@"unity" withArgs:@"global", @"collab", @"null", nil];
  
  [socket sendXML:[joinMessage XMLDocument]];
  
  [joinMessage release];
}

- (void)handle_upcOnClientAttributeUpdate:(UPCMessage*)pMessage
{
  NSString* cid = [[pMessage args] objectAtIndex:2];
  NSString* key = [[pMessage args] objectAtIndex:3];
  NSString* val = [[pMessage args] objectAtIndex:4];
  
  Client* client = [clients getClient:cid];
  if (!client) {
    client = [Client fromId:cid];
    [clients addClient:client];
  }
  
  [client setAttribute:key withValue:val];
  
  [usersTable reloadData];
  
  NSLog(@"%@: '%@' -> '%@'", cid, key, val);
}

- (void)handle_upcOnJoinRoom:(UPCMessage*)pMessage
{
  [outputRenderer renderInfoMessage:@"Welcome to Collab!"];
  
  Client* client = [clients getClient:clientId];
  
  NSString* msg = [NSString stringWithFormat:@"<b>%@ has joined.</b>", [client username]];
  
  UPCMessage* joinMessage =
    [[UPCMessage alloc] initWithMethod:@"invokeOnRoom" withRoomId:@"unity" withArgs:@"joinMessage", @"collab.global", @"false", msg, nil];
  
  [socket sendXML:[joinMessage XMLDocument]];
  
  [joinMessage release];
  
  [outputRenderer renderJoinMessage:client];
}

- (void)handle_displayMessage:(UPCMessage*)pMessage
{
  NSString* cid = [[pMessage args] objectAtIndex:0];
  NSString* msg = [[pMessage args] objectAtIndex:1];
  
  Client* client = [clients getClient:cid];
  if (!client) {
    client = [Client fromId:cid];
    [clients addClient:client];
  }
  
  [outputRenderer renderPublicMessage:msg sender:client];
}

- (void)handle_upcSetClientList:(UPCMessage*)pMessage
{
  int i;
  
  for (i = 2; i < [pMessage.args count] - 2; i += 3) {
    NSString* cid   = [pMessage.args objectAtIndex:i];
    
    if (![clientId isEqualToString:cid]) {
      NSString* attrs = [pMessage.args objectAtIndex:i+1];
      
      [clients addClient:[Client fromId:cid andUnityAttributeString:attrs]];
    }
  }
}

- (void)handle_meText:(UPCMessage*)pMessage
{
  NSString* cid = [[pMessage args] objectAtIndex:0];
  NSString* msg = [[pMessage args] objectAtIndex:1];
  
  Client* client = [clients getClient:cid];
  if (!client) {
    client = [Client fromId:cid];
    [clients addClient:client];
  }
  
  [outputRenderer renderActionMessage:msg sender:client];
}

- (void)handle_joinMessage:(UPCMessage*)pMessage
{
  NSString* cid = [[pMessage args] objectAtIndex:0];
  NSString* msg = [[pMessage args] objectAtIndex:1];
  
  Client* client = [clients getClient:cid];
  if (!client) {
    client = [Client fromId:cid];
    [clients addClient:client];
  }
  
  NSLog(@"MESSAGE: %@", msg);
  
  /* Nasty but nescessary hack due to flaw in Collab protocol */
  if ([msg length] > 25 && [[msg substringToIndex:25] isEqualToString:@"<font color=\"#B1661D\"><b>"]) {
    int start = 25 + [[client username] length] + 16;
    int end   = [msg length] - 7 - start;
    [outputRenderer renderPrivateMessage:[msg substringWithRange:NSMakeRange(start, end)] sender:client];
  }
  /* Another nasty hack, this time for Alice.. */
  else if ([msg length] > 25 && [[msg substringToIndex:25] isEqualToString:@"<font color='#5A3A87'><b>"]) {
    int start = 25 + [[client username] length] + 15;
    int end   = [msg length] - 7 - start;
    [outputRenderer renderAliceMessage:[msg substringWithRange:NSMakeRange(start, end)] sender:client];
  }
  else {
    [outputRenderer renderJoinMessage:client];
  }
}

- (void)handle_upcOnRemoveClient:(UPCMessage*)pMessage
{
  NSString* cid = [[pMessage args] objectAtIndex:2];
  
  Client* client = [clients getClient:cid];
  if (!client) {
    client = [Client fromId:cid];
    [clients addClient:client];
  }
  
  [outputRenderer renderQuitMessage:client];
  
  [clients removeClient:cid];
}

- (void)handle_upcOnAddClient:(UPCMessage*)pMessage
{
  NSString* cid  = [[pMessage args] objectAtIndex:2];
  NSString* args = [[pMessage args] objectAtIndex:3];
  
  [clients addClient:[Client fromId:cid andUnityAttributeString:args]];
}

- (void)handle_receiveBotMsg:(UPCMessage*)pMessage
{
  NSString* cid = [[pMessage args] objectAtIndex:0];
  NSString* msg = [[pMessage args] objectAtIndex:1];
  NSString* bot = [[pMessage args] objectAtIndex:2];
  
  if ([@"Alice" isEqualToString:bot]) {
    Client* client = [clients getClient:cid];
    if (client) {
      [outputRenderer renderAliceReply:msg recipient:client];
    }
  }
}

#pragma mark -

- (void)command_me:(NSString*)args
{
  [self sendAction:args];
}

- (void)command_whois:(NSString*)args
{
  Client* client = [clients getClientByUsername:args];
  if (client) {
    NSString* key;
    NSEnumerator* keys = [[client attributes] keyEnumerator];
    
    while ((key = [keys nextObject]) != nil) {
      [outputRenderer renderInfoMessage:[NSString stringWithFormat:@"%@: %@", key, [[client attributes] valueForKey:key]]];
    }
  }
  else {
    [outputRenderer renderInfoMessage:[NSString stringWithFormat:@"No user named '%@'", args]];
  }
}

- (void)command_msg:(NSString*)args
{
  [outputRenderer renderInfoMessage:@"Outgoing private messages not yet supported, sorry :-)"]; 
}

- (void)command_nick:(NSString*)args
{
  [self sendAttributeUpdate:args forKey:@"username"];
}

- (void)command_clear:(NSString*)args
{
  [self clearOutput:nil];
}

@end
