//
//  SpringSortAppDelegate.h
//  SpringSort
//
//  Created by Eric Wolter on 13.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SpringSortAppDelegate : NSObject <NSApplicationDelegate> {
@private
	NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
