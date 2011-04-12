//
//  SpringSortAppDelegate.h
//  SpringSort
//
//  Created by Eric Wolter on 17.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SpringBoardView.h"

@interface SpringSortAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	SpringBoardView *springBoardView;
}
@property (assign) IBOutlet SpringBoardView *springBoardView;
@property (assign) IBOutlet NSWindow *window;

@end
