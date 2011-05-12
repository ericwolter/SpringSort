//
//  MySplitViewController.m
//  SpringSort
//
//  Created by Eric Wolter on 03.05.11.
//  Copyright 2011 private. All rights reserved.
//

#import "MySplitViewController.h"

@implementation MySplitViewController

@synthesize mySplitView;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(NSRect)splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex
{
	return NSZeroRect;
}

-(IBAction)clickedToggle:(NSButton *)sender
{
	if ([sender state] == NSOnState) {
		[self uncollapseRightView];
	} else {
		[self collapseRightView];
	}
}
	 
 -(void)collapseRightView
 {	 
//	 NSView *left  = [[[self mySplitView] subviews] objectAtIndex:0];
	 NSView *right = [[[self mySplitView] subviews] objectAtIndex:1];
//	 NSRect leftFrame = [left frame];
	 NSRect rightFrame = [right frame];
	 [NSAnimationContext beginGrouping];
	 [[NSAnimationContext currentContext] setDuration:0.2];
	 [[right animator] setFrameSize:NSMakeSize(0, rightFrame.size.height)];
	 [NSAnimationContext endGrouping];
 }

-(void)uncollapseRightView
{
	NSView *left  = [[[self mySplitView] subviews] objectAtIndex:0];
	NSView *right = [[[self mySplitView] subviews] objectAtIndex:1];
	NSRect leftFrame = [left frame];
	NSRect rightFrame = [right frame];
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.2];
	[[left animator] setFrameSize:NSMakeSize(560, leftFrame.size.height)];
	[[right animator] setFrameSize:NSMakeSize(292, rightFrame.size.height)];
	[NSAnimationContext endGrouping];
}

@end
