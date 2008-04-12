//
//  OutputRenderer.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 11/04/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import "OutputRenderer.h"
#import "UPCMessage.h"
#import "Collab.h"
#import "Client.h"

#import <WebKit/WebView.h>
#import <WebKit/WebFrame.h>
#import <WebKit/DOMExtensions.h>

@interface OutputRenderer (Private)
- (DOMDocument*)document;

- (DOMElement*)createElement:(NSString*)name;
- (DOMElement*)createElement:(NSString*)name withClass:(NSString*)css;
- (DOMElement*)createElement:(NSString*)name withContent:(NSString*)content withClass:(NSString*)css;

- (void)writeElement:(DOMElement*)elem;
@end

@implementation OutputRenderer

- (void)renderInfoMessage:(NSString*)message
{
  [self writeElement:[self createElement:@"p" withContent:message withClass:@"msg_info"]];
}

- (void)renderPublicMessage:(NSString*)message sender:(Client*)sender
{
  DOMElement* p;
  
  if ([[sender clientId] isEqualToString:[collab clientId]]) {
    p = [self createElement:@"p" withClass:@"msg_self"];
  }
  else {
    p = [self createElement:@"p" withClass:@"msg_public"];
  }
  
  [p appendChild:[self createElement:@"span" withContent:[sender username] withClass:@"sender"]];
  
  [self writeElement:p];
}

- (void)renderPrivateMessage:(NSString*)message sender:(Client*)sender
{
  /* @todo */
}

- (void)renderActionMessage:(NSString*)message sender:(Client*)sender
{
  NSString* text = [NSString stringWithFormat:@"%@ joined.", [sender username]];
  [self writeElement:[self createElement:@"p" withContent:text withClass:@"msg_action"]];
}

- (void)renderJoinMessage:(Client*)sender
{
  NSString* message = [NSString stringWithFormat:@"%@ joined.", [sender username]];
  [self writeElement:[self createElement:@"p" withContent:message withClass:@"msg_join"]];
}

- (void)renderQuitMessage:(Client*)sender
{
  NSString* message = [NSString stringWithFormat:@"%@ left.", [sender username]];
  [self writeElement:[self createElement:@"p" withContent:message withClass:@"msg_quit"]];
}

#pragma mark -

- (DOMDocument*)document
{
  return [[webView mainFrame] DOMDocument];
}

- (DOMElement*)createElement:(NSString*)name
{
  return [[self document] createElement:name];
}

- (DOMElement*)createElement:(NSString*)name withClass:(NSString*)css
{
  DOMElement* elem = [self createElement:name];
  [elem setAttribute:@"class" value:css];
  return elem;
}

- (DOMElement*)createElement:(NSString*)name withContent:(NSString*)content withClass:(NSString*)css
{
  DOMElement* elem = [self createElement:name withClass:css];
  DOMText* inner   = [[self document] createTextNode:content];
  
  [elem appendChild:inner];
  
  return elem;
}

- (void)writeElement:(DOMElement*)elem
{
  [[[self document] getElementById:@"main"] appendChild:elem];
  
  /* @todo fix this warning.. */
  DOMHTMLBodyElement* body = [[[webView mainFrame] DOMDocument] body];
  [body setValue:[body valueForKey:@"scrollHeight"] forKey:@"scrollTop"];
}

@end
