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

@synthesize window, springSortController;
@synthesize sortingStrategies;
@synthesize deviceCentral;

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
	[self.window setBackgroundColor:[NSColor whiteColor]];
	[indeterminateProgress startAnimation:self];
	[messageLabel setStringValue:@"Looking for device..."];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.deviceCentral = [[DeviceCentral alloc] init];
	[self.deviceCentral setDelegate:self];
}

- (IBAction)sortByAlphabet:(NSButton *)sender
{
	if (!self.springSortController) {
		return;
	}
	
	SortingByAlphabet *s = [[SortingByAlphabet alloc] initWithController:self.springSortController];
	springBoardView.state = [s newSortedState:self.springSortController.state];
	[s release];
	
	[springBoardView setNeedsDisplay:YES];
}

- (IBAction)sortByGenre:(NSButton *)sender
{
	if (!self.springSortController) {
		return;
	}
	
	SortingByGenre *s = [[SortingByGenre alloc] initWithController:self.springSortController];
	springBoardView.state = [s newSortedState:self.springSortController.state];
	[s release];
	
	[springBoardView setNeedsDisplay:YES];
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

- (IBAction)reloadClicked:(NSButton *)sender
{
	return;
}

-(void)reload:(Device *)device
{
	void (^jobFinished)(void) = ^{
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[self.springSortController removeProgressListener:self];
			[springBoardView setNeedsDisplay:YES];
			[loadingProgress setHidden:YES];
			[indeterminateProgress stopAnimation:self];
			[messageLabel setStringValue:[NSString stringWithFormat:@"%@ connected", device.name]];
		}];
    };
	
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	NSBlockOperation* theOp = [NSBlockOperation blockOperationWithBlock: ^{
		[messageLabel setStringValue:@"Loading icon state..."];
		[loadingProgress setHidden:NO];
		[loadingProgress setControlTint:NSGraphiteControlTint];
		SpringSortController *controller = [[SpringSortController alloc] initWithDevice:device];
		[controller addProgressListener:self];
		[controller download];
		springBoardView.controller = controller;
		springBoardView.state = controller.state;
		self.springSortController = controller;
		[controller release];
	}];

    [theOp setCompletionBlock:jobFinished];
	[queue addOperation:theOp];
}

-(void)deviceAdded:(Device *)theDevice
{
	[self reload:theDevice];
}

-(void)deviceRemoved:(Device *)theDevice
{
	NSString *message = [NSString stringWithFormat:@"%@ disconnected", theDevice.name];
	[messageLabel setStringValue:message];
	
	[indeterminateProgress startAnimation:self];
	[messageLabel setStringValue:@"Looking for device..."];
}

-(void)reportProgress:(NSUInteger)theValue max:(NSUInteger)theMax
{
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		double d = (theValue/(double)theMax) * 100;
		[loadingProgress setDoubleValue:d];
		[messageLabel setStringValue:[NSString stringWithFormat:@"Loading %i of %i icons",(int)theValue, (int)theMax]];
	}];
}

@end
