//
//  XMLSocket.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 30/03/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NetSocket.h"

#define DEBUG_TRAFFIC 1

@class NullTerminatedTokenBuffer;

@interface XMLSocket : NetSocket {
  NullTerminatedTokenBuffer* buffer;
}

@property(readonly) NullTerminatedTokenBuffer* buffer;
- (id)init;
- (id)initWithDelegate:(id)pDelegate;

- (void)dealloc;

- (void)sendXML:(NSXMLDocument*)pXML;
@end

#pragma mark -

@interface NSObject (XMLSocketDelegate)
- (void)xmlsocket:(XMLSocket*)pSocket xmlAvailable:(NSXMLDocument*)pXML;
@end

#pragma mark -

@interface NetSocket (XMLSocketOverrides)
- (void)_cfsocketDataAvailable;
@end
