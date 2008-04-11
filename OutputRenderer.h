//
//  OutputRenderer.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 11/04/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class UPCMessage;
@class WebView;
@class DOMDocument;
@class DOMElement;

@interface OutputRenderer : NSObject {
  IBOutlet WebView* webView;
}

- (void)outputMessage:(UPCMessage*)message;

- (void)outputInfoMessage:(NSString*)message;
- (void)outputSelfMessage:(NSString*)message withUsername:(NSString*)username;

- (DOMDocument*)document;

- (DOMElement*)createElement:(NSString*)name;
- (DOMElement*)createElement:(NSString*)name withClass:(NSString*)css;
- (DOMElement*)createElement:(NSString*)name withContent:(NSString*)content withClass:(NSString*)css;

- (void)writeElement:(DOMElement*)elem;

@end
