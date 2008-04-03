//
//  NullTerminatedTokenBuffer.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 29/03/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define NULL_TERMINATOR @"\0"

@class NetSocket;

@interface NullTerminatedTokenBuffer : NSObject {
  id delegate;
  
  NSMutableString* buffer;
}

@property(readwrite, assign) id delegate;
- (id)init;

- (void)appendData:(NSString*)pData;
- (void)clear;
@end

#pragma mark -

@interface NSObject (NullTerminatedTokenBufferDelegate)
- (void)nullTerminatedTokenBuffer:(id)pBuffer tokenAvailable:(NSString*)pToken;
@end
