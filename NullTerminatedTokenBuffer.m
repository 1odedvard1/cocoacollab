//
//  NullTerminatedTokenBuffer.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 29/03/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import "NullTerminatedTokenBuffer.h"

@implementation NullTerminatedTokenBuffer

@synthesize delegate;

- (id)init
{
  self = [super init];
  [self clear];
  return self;
}

- (void)appendData:(NSString*)data
{
  [buffer appendString:data];
  
  NSArray* parts = [buffer componentsSeparatedByString:NULL_TERMINATOR];
  
  int i;
  for (i = 0; i < [parts count] - 1; i++) {
    NSString* part = [parts objectAtIndex:i];
    if ([part length] > 0) {
      if ([delegate respondsToSelector:@selector(nullTerminatedTokenBuffer:tokenAvailable:)]) {
        [delegate nullTerminatedTokenBuffer:self tokenAvailable:part];
      }
    }
    [buffer deleteCharactersInRange:NSMakeRange(0, [part length])];
  }
  
  NSString* end = [buffer substringFromIndex:[buffer length]];
  if ([NULL_TERMINATOR isEqualToString:end]) {
    if ([buffer length] > 1 && [delegate respondsToSelector:@selector(nullTerminatedTokenBuffer:tokenAvailable:)]) {
      [delegate nullTerminatedTokenBuffer:self tokenAvailable:buffer];
    }
    [buffer deleteCharactersInRange:NSMakeRange(0, [buffer length])];
  }
}

- (void)clear
{
  [buffer release];
  buffer = [[NSMutableString alloc] initWithString:@""];
}

@end
