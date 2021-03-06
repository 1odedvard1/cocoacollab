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

- (id)initWithDelegate:(id)pDelegate
{
  self = [self init];
  [self setDelegate:pDelegate];
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
  NSString* data = [[pXML XMLString] stringByAppendingString:NULL_TERMINATOR];
  [self writeString:data encoding:NSUTF8StringEncoding];
  
#ifdef DEBUG_TRAFFIC
  NSLog(@"->> %@", data);
#endif
}

#pragma mark -

- (void)_cfsocketDataAvailable
{
  [super _cfsocketDataAvailable];
  [buffer appendData:[self readString:NSUTF8StringEncoding]];
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
  
#ifdef DEBUG_TRAFFIC
  NSLog(@"<<- %@", pToken);
#endif
}

@end
