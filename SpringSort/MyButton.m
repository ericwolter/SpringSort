//
//  MyButton.m
//  SpringSort
//
//  Created by Eric Wolter on 09.05.11.
//  Copyright 2011 private. All rights reserved.
//

#import "MyButton.h"

static NSImage *leftTriangle, *rightTriangle, *leftTriangleHighlight, *rightTriangleHighlight;

@implementation MyButton

+(void)initialize 
{
	NSBundle *bundle = [NSBundle bundleForClass:[MyButton class]];
	
	leftTriangle = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"LeftFacingTriangle.png"]];
	rightTriangle = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"RightFacingTriangle.png"]];
	leftTriangleHighlight = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"LeftFacingTriangleHighlight.png"]];
	rightTriangleHighlight = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"RightFacingTriangleHighlight.png"]];
}

-(void)awakeFromNib
{
	[self setButtonType:NSToggleButton];
	[self setImage:leftTriangle];
	[self setAlternateImage:rightTriangle];
}

- (void)updateTrackingAreas
{
	[super updateTrackingAreas];
	
	if (trackingArea)
	{
		[self removeTrackingArea:trackingArea];
		[trackingArea release];
	}
	
	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
	trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)event
{
	[self setImage:leftTriangleHighlight];
	[self setAlternateImage:rightTriangleHighlight];
}

- (void)mouseExited:(NSEvent *)event
{
	[self setImage:leftTriangle];
	[self setAlternateImage:rightTriangle];
}

@end
