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

@interface SimpleController : NSWindowController {
  NSString* clientId;
  
  XMLSocket* socket;
  
  ClientList* clients;
  
  NSImage* menuIcon;
  NSStatusItem* statusItem;
  
  IBOutlet NSTextField* inputText;
  IBOutlet NSTextView* outputText;
  IBOutlet NSTableView* usersTable;
}

- (id)init;
- (void)dealloc;
- (void)awakeFromNib;

#pragma mark -

- (IBAction)connect:(id)sender;
- (IBAction)disconnect:(id)sender;
- (IBAction)processInput:(id)sender;

@end

#pragma mark -

@interface SimpleController (UserInterface)
- (void)appendOutputText:(NSString*)text;
@end
