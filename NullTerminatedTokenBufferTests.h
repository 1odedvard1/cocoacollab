//
//  NullTerminatedSocketBufferTests.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 29/03/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class NullTerminatedTokenBuffer;

typedef enum _nullTerminatedTokenBufferTestType {
  TEST_SPLIT,
  TEST_UNSPLIT
} NullTerminatedTokenBufferTestType;

@interface NullTerminatedTokenBufferTests : SenTestCase {
  NullTerminatedTokenBufferTestType testType;
  int packetCount;
}

- (void)setUp;

- (void)test_appendData_split;
- (void)test_appendData_unsplit;

- (void)nullTerminatedTokenBuffer:(NullTerminatedTokenBuffer*)pBuffer tokenAvailable:(NSString*)pToken;

@end
