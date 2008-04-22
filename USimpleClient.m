//
//  USimpleClient.m
//  CocoaCollab
//
//  Created by Cliff Rowley on 16/04/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import "USimpleClient.h"
#import "XMLSocket.h"

@implementation USimpleClient

@synthesize socket;

- (id)init
{
  self = [super init];
  return self;
}

- (void)dealloc
{
  [socket release];
  [super dealloc];
}

#pragma mark -

- (void)connect
{
  if (socket && [socket isConnected]) {
    [self disconnect];
  }
  
  socket = [[XMLSocket alloc] init];
  
  [socket connectToHost:COLLAB_HOST port:COLLAB_PORT];
}

- (void)disconnect
{
  [socket close];
  [socket release];
}

- (void)invokeMethod:(NSString*)pName ns:(NSString*)pNamespace roomId:(NSString*)pRoomId
{
  
}

@end
