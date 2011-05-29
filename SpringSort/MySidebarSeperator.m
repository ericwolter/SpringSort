//
//  MySidebarSeperator.m
//  SpringSort
//
//  Created by Eric Wolter on 25.05.11.
//  Copyright 2011 private. All rights reserved.
//

#import "MySidebarSeperator.h"

static NSImage *image;

@implementation MySidebarSeperator

+ (void)initialize
{
	NSBundle *bundle = [NSBundle bundleForClass:[MySidebarSeperator class]];
	
	image = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"SidebarSeperator.png"]];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        frame.size.width = 277.0f;
		frame.size.height = 2.0f;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[image drawInRect:NSMakeRect(0.0f, 0.0f, 277.0f, 2.0f) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
}

@end
