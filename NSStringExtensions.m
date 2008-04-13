//
//  NSStringExtensions.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 13/04/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import "NSStringExtensions.h"


@implementation NSString (NSStringExtensions)

+ (NSString *)trim:(NSString *)s {
  NSInteger len = [s length];
  if (len == 0) {
    return s;
  }
  const char *data = [s UTF8String];
  NSInteger start;
  for (start = 0; start < len && data[start] <= 32; ++start) {
    // just advance
  }
  NSInteger end;
  for (end = len - 1; end > start && data[end] <= 32; --end) {
    // just advance
  }
  return [s substringWithRange:NSMakeRange(start, end - start + 1)];
}

@end
