//
//  OutputRenderer.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 11/04/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class UPCMessage;
@class SimpleController;
@class WebView;
@class DOMDocument;
@class DOMElement;
@class Client;

@interface OutputRenderer : NSObject {
  IBOutlet SimpleController* controller;
  IBOutlet WebView* webView;
}

- (void)renderInfoMessage:(NSString*)message;
- (void)renderPublicMessage:(NSString*)message sender:(Client*)sender;
- (void)renderPrivateMessage:(NSString*)message sender:(Client*)sender;
- (void)renderActionMessage:(NSString*)message sender:(Client*)sender;
- (void)renderJoinMessage:(Client*)sender;
- (void)renderQuitMessage:(Client*)sender;

- (void)clear;

@end
