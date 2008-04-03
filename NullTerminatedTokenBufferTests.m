//
//  NullTerminatedSocketBufferTests.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 29/03/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import "NullTerminatedTokenBufferTests.h"
#import "NullTerminatedTokenBuffer.h"

@implementation NullTerminatedTokenBufferTests

- (void)setUp
{
  packetCount = 0;
}

- (void)test_appendData_unsplit
{
  testType = TEST_UNSPLIT;
  
  NullTerminatedTokenBuffer* buffer = [[NullTerminatedTokenBuffer alloc] init];
  [buffer setDelegate:self];
  
  [buffer appendData:@"DATA1\0"];
  [buffer appendData:@"DATA2\0"];
  
  STAssertTrue(packetCount == 2, @"Packet count is '%i'", packetCount);
}

- (void)test_appendData_split
{
  testType = TEST_SPLIT;
  
  NullTerminatedTokenBuffer* buffer = [[NullTerminatedTokenBuffer alloc] init];
  [buffer setDelegate:self];
  
  [buffer appendData:@"DATA1"];
  [buffer appendData:@"DATA2\0"];
  
  STAssertTrue(packetCount == 1, @"Packet count is '%i'", packetCount);
}

- (void)nullTerminatedTokenBuffer:(NullTerminatedTokenBuffer*)pBuffer tokenAvailable:(NSString*)pToken
{
  switch (testType) {
    case TEST_SPLIT:
      STAssertTrue([@"DATA1DATA2" isEqualToString:pToken], @"Packet data is '%@', should have been 'DATA1DATA2'", pToken);
      break;
      
    case TEST_UNSPLIT:
      if (packetCount == 0) {
        STAssertTrue([@"DATA1" isEqualToString:pToken], @"Packet data is '%@', should have been 'DATA1'", pToken);
      }
      else {
        STAssertTrue([@"DATA2" isEqualToString:pToken], @"Packet data is '%@', should have been 'DATA2'", pToken);
      }
      
      break;
  }
  packetCount++;
}

@end
