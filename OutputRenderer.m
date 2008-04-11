//
//  OutputRenderer.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 11/04/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import "OutputRenderer.h"
#import "UPCMessage.h"

#import <WebKit/WebView.h>
#import <WebKit/WebFrame.h>
#import <WebKit/DOMExtensions.h>

@implementation OutputRenderer

- (void)outputMessage:(UPCMessage*)message
{
  if ([@"upc" isEqualToString:[message method]]) {
  }
}

- (void)outputInfoMessage:(NSString*)message
{
  [self writeElement:[self createElement:@"p" withContent:message withClass:@"msg_info"]];
}

- (void)outputSelfMessage:(NSString*)message withUsername:(NSString*)username
{
  DOMElement* p = [self createElement:@"p" withClass:@"msg_self"];
  DOMElement* s = [self createElement:@"span" withContent:username withClass:@"sender"];
  [p appendChild:s];
  
  [self writeElement:p];
}

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
  [webView scrollPageUp:nil];
}

@end
