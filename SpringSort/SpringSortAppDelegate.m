//
//  SpringSortAppDelegate.m
//  SpringSort
//
//  Created by Eric Wolter on 13.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SpringSortAppDelegate.h"
#import "SpringBoardView.h"

#import "Device.h"
#import "UsbUtility.h"

#import "SpringSortController.h"

@implementation SpringSortAppDelegate

@synthesize window, springBoardView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	Device *d = [[Device alloc] initWithUuid:[UsbUtility firstDeviceUuid]];
	
	SpringSortController *controller = [[SpringSortController alloc] initWithDevice:d];
	
	self.springBoardView.controller = controller;
	[self.springBoardView setNeedsDisplay:YES];
	[controller release];
	[d release];
}

@end
