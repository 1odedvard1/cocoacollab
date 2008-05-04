//
//  Collab.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 03/05/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Client;

@interface Collab : NSObject {
  IBOutlet id delegate;
}

- (IBAction)connect;
- (IBAction)disconnect;

- (IBAction)sendPublicMessage:(NSString*)pMessage;
- (IBAction)sendPrivateMessage:(NSString*)pMessage toClient:(Client*)pClient;
- (IBAction)sendAction:(NSString*)pMessage;

@end
