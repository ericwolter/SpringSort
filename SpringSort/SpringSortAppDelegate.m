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

@implementation SpringSortAppDelegate

@synthesize window, springBoardView, springSortController;
@synthesize sortingStrategies;

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
	[self.window setBackgroundColor:[NSColor colorWithCalibratedRed:56.0f/255.0f green:56.0f/255.0f blue:56.0f/255.0f alpha:1.0f]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	Device *d = [[Device alloc] initWithUuid:[UsbUtility firstDeviceUuid]];
	
	SpringSortController *controller = [[SpringSortController alloc] initWithDevice:d];
	self.springBoardView.controller = controller;
	self.springBoardView.state = controller.state;
	[d release];
	
	self.springSortController = controller;
	[controller release];
	
	NSMutableArray *ss = [NSMutableArray array];
	SortingStrategy *s = [[SortingByAlphabet alloc] initWithController:self.springSortController];
	[ss addObject:s];
	[s release];
	s = [[SortingByGenre alloc] initWithController:self.springSortController];
	[ss addObject:s];
	[s release];
	
	self.sortingStrategies = ss;
	
	[self.springBoardView setNeedsDisplay:YES];
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

@end
