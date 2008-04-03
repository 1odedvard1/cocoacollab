//
//  XMLSocket.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 30/03/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import "NetSocket.h"
#import "XMLSocket.h"
#import "NullTerminatedTokenBuffer.h"

@interface XMLSocket (Private)
- (void)nullTerminatedTokenBuffer:(NullTerminatedTokenBuffer*)pBuffer tokenAvailable:(NSString*)pToken;
@end

@implementation XMLSocket

@synthesize buffer;

- (id)init
{
  self = [super init];
  buffer = [[NullTerminatedTokenBuffer alloc] init];
  [buffer setDelegate:self];
  return self;
}

- (void)dealloc
{
  [buffer release];
  [super dealloc];
}

#pragma mark -

- (void)sendXML:(NSXMLDocument*)pXML
{
  [self writeString:[[pXML XMLString] stringByAppendingString:NULL_TERMINATOR] encoding:NSUTF8StringEncoding];
}

#pragma mark -

- (void)_cfsocketDataAvailable
{
  [super _cfsocketDataAvailable];
  [buffer appendData:[NSString stringWithCString:[mIncomingBuffer bytes] length:[mIncomingBuffer length]]];
}

#pragma mark -

- (void)nullTerminatedTokenBuffer:(NullTerminatedTokenBuffer*)pBuffer tokenAvailable:(NSString*)pToken
{
  NSError* err = [[NSError alloc] init];
  NSXMLDocument* xml = [[[NSXMLDocument alloc] initWithXMLString:pToken options:0 error:&err] autorelease];
  
  if ([mDelegate respondsToSelector:@selector(xmlsocket:xmlAvailable:)]) {
    [mDelegate xmlsocket:self xmlAvailable:xml];
  }
  
  [err release];
}

@end
