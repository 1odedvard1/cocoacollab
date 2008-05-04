//
//  AppController.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 03/05/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Collab;

@interface AppController : NSObject {
  Collab* collab;
}

@property(readwrite, assign) Collab* collab;

- (IBAction)connect;
- (IBAction)disconnect;

- (IBAction)processUserInput:(NSString*)pUserInput;

- (IBAction)setClientAttribute:(NSString*)pValue forKey:(NSString*)pKey;

@end
