//
//  SimpleController.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 31/03/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define DEFAULT_HOST @"unity.collab.nl"
#define DEFAULT_PORT 9110

@class XMLSocket;
@class NetSocket;
@class ClientList;
@class WebView;
@class OutputRenderer;

@interface SimpleController : NSWindowController {
  NSString* clientId;
  
  XMLSocket* socket;
  
  ClientList* clients;
  
  NSImage* menuIcon;
  NSStatusItem* statusItem;
  
  IBOutlet NSTextField* inputText;
  IBOutlet NSTableView* usersTable;
  IBOutlet WebView* webView;
  IBOutlet OutputRenderer* outputRenderer;
}

@property(readonly) NSString* clientId;

- (id)init;
- (void)dealloc;
- (void)awakeFromNib;

#pragma mark -

- (IBAction)connect:(id)sender;
- (IBAction)disconnect:(id)sender;
- (IBAction)processInput:(id)sender;
- (IBAction)toggleWindowVisibility:(id)sender;
- (IBAction)clearOutput:(id)sender;
- (IBAction)launchWiki:(id)sender;

@end

#pragma mark -

@interface SimpleController (Commands)
- (void)command_me:(NSString*)args;
- (void)command_whois:(NSString*)args;
- (void)command_msg:(NSString*)args;
- (void)command_nick:(NSString*)args;
@end