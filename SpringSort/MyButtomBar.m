//
//  MyButtomBar.m
//  SpringSort
//
//  Created by Eric Wolter on 27.05.11.
//  Copyright 2011 private. All rights reserved.
//

#import "MyButtomBar.h"

//static NSColor *backgroundColor;
static NSImage *bgImage;

@implementation MyButtomBar

+ (void)initialize
{
	NSBundle *bundle = [NSBundle bundleForClass:[MyButtomBar class]];
	bgImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"BottomBarBackground.png"]];
}

- (void)drawRect:(NSRect)dirtyRect
{
	int bgWidth = (int)bgImage.size.height;
	for(int i = 0; i < [self bounds].size.width; i += bgWidth) {
		[bgImage drawInRect:NSMakeRect(i, 0, bgImage.size.width, bgImage.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
	}
}

@end
