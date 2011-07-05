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
#import "SbPage.h"

#import "SortingWorkflow.h"
#import	"PrepareFlat.h"
#import "SortingByDisplayName.h"
#import "FileNothing.h"
#import "MergeNothing.h"
#import "RetouchDefault.h"

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

- (IBAction)reloadState:(NSButton *)sender
{
	if (!self.springSortController) {
		return;
	}
	[self.springSortController reloadState];
	springBoardView.state = self.springSortController.state;
	[springBoardView setNeedsDisplay:YES];
}

- (IBAction)sortByAlphabet:(NSButton *)sender
{
	if (!self.springSortController) {
		return;
	}
	
	id<PrepareStep> prepareStep = [[PrepareFlat alloc] init];
	id<SortStep> sortStep = [[SortingByDisplayName alloc] init];
	id<FileStep> fileStep = [[FileNothing alloc] init];
	id<MergeStep> mergeStep = [[MergeNothing alloc] init];
	id<RetouchStep> retouchStep = [[RetouchDefault alloc] init];
	
	NSArray *steps = [[NSArray alloc] initWithObjects:prepareStep,sortStep,fileStep,mergeStep,retouchStep, nil];
	[prepareStep release];
	[sortStep release];
	[fileStep release];
	[mergeStep release];
	[retouchStep release];
	SortingWorkflow *workflow = [[SortingWorkflow alloc] initWithSteps:steps];
	[steps release];
	SbState *sortedState = [workflow newSortedState:self.springSortController.state];
	self.springSortController.state = sortedState;
	springBoardView.state = sortedState;
	[sortedState release];
	[workflow release];
	
	[springBoardView setNeedsDisplay:YES];
}

- (IBAction)sortByGenre:(NSButton *)sender
{
	if (!self.springSortController) {
		return;
	}
	
//	SortingByGenre *s = [[SortingByGenre alloc] initWithController:self.springSortController];
//	springBoardView.state = [s newSortedState:self.springSortController.state];
//	[s release];
	
	[springBoardView setNeedsDisplay:YES];
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
