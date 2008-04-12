//
//  OutputRenderer.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 11/04/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class UPCMessage;
@class Collab;
@class WebView;
@class DOMDocument;
@class DOMElement;
@class Client;

@interface OutputRenderer : NSObject {
  IBOutlet Collab* collab;
  IBOutlet WebView* webView;
}

- (void)renderInfoMessage:(NSString*)message;
- (void)renderPublicMessage:(NSString*)message sender:(Client*)sender;
- (void)renderPrivateMessage:(NSString*)message sender:(Client*)sender;
- (void)renderActionMessage:(NSString*)message sender:(Client*)sender;
- (void)renderJoinMessage:(Client*)sender;
- (void)renderQuitMessage:(Client*)sender;

@end
