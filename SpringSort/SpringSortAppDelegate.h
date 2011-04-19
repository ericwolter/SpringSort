//
//  SpringSortAppDelegate.h
//  SpringSort
//
//  Created by Eric Wolter on 13.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SpringBoardView;

@interface SpringSortAppDelegate : NSObject <NSApplicationDelegate> {
@private
	NSWindow *window;
	SpringBoardView *springBoardView;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SpringBoardView *springBoardView;

@end
