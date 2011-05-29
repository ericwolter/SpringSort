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

#import "SortingByAlphabet.h"
#import "SortingByGenre.h"

@interface SpringSortAppDelegate()
-(void)reloadFromDevice;
@end

@implementation SpringSortAppDelegate

@synthesize window, springBoardView, springSortController;
@synthesize sortingStrategies;

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
	[self.window setBackgroundColor:[NSColor whiteColor]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self reloadFromDevice];
}

- (IBAction)sortByAlphabet:(NSButton *)sender
{
	if (!self.springSortController) {
		return;
	}
	
	SortingByAlphabet *s = [[SortingByAlphabet alloc] initWithController:self.springSortController];
	self.springBoardView.state = [s newSortedState:self.springSortController.state];
	[s release];
	
	[self.springBoardView setNeedsDisplay:YES];
}

- (IBAction)sortByGenre:(NSButton *)sender
{
	if (!self.springSortController) {
		return;
	}
	
	SortingByGenre *s = [[SortingByGenre alloc] initWithController:self.springSortController];
	self.springBoardView.state = [s newSortedState:self.springSortController.state];
	[s release];
	
	[self.springBoardView setNeedsDisplay:YES];
}

-(void)insertObject:(SortingStrategy *)s inSortingStrategiesAtIndex:(NSUInteger)index {
    [sortingStrategies insertObject:s atIndex:index];
}

-(void)removeObjectFromSortingStrategiesAtIndex:(NSUInteger)index {
    [sortingStrategies removeObjectAtIndex:index];
}

-(void)setSortingStrategies:(NSMutableArray *)a {
    sortingStrategies = a;
}

-(NSArray*)sortingStrategies {
    return sortingStrategies;
}

- (IBAction)reload:(NSButton *)sender
{
	[self reloadFromDevice];
}

-(void)reloadFromDevice
{
	NSString *uuid = [UsbUtility firstDeviceUuid];
	if (!uuid) {
		return;
	}
	Device *d = [[Device alloc] initWithUuid:uuid];
	
	SpringSortController *controller = [[SpringSortController alloc] initWithDevice:d];
	self.springBoardView.controller = controller;
	self.springBoardView.state = controller.state;
	[d release];
	
	self.springSortController = controller;
	[controller release];
	
	[self.springBoardView setNeedsDisplay:YES];
}

@end
