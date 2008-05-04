//
//  MainWindowController.h
//  CocoaCollab
//
//  Created by Cliff Rowley on 03/05/2008.
//  Copyright 2008 EleventyTen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainWindowController : NSObject {
  IBOutlet NSTextView* inputView;
  IBOutlet WebView* outputView;
  IBOutlet NSTableView* usersView;
}

@end
