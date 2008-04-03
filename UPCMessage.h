//
//  CollabMessage.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 21/03/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UPCMessage : NSObject {
  NSString* method;
  NSString* roomId;
  NSMutableArray*  args;
}

@property(readwrite, copy) NSString* method;
@property(readwrite, copy) NSString* roomId;
@property(readwrite, assign) NSMutableArray* args;

- (id)initWithMethod:(NSString*)pMethod;
- (id)initWithMethod:(NSString*)pMethod withArgs:firstArg, ...;

- (NSXMLDocument*)XMLDocument;

+ (id)fromXMLDocument:(NSXMLDocument*)pXML;

@end
