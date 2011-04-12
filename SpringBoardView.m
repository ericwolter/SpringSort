//
//  SpringBoardView.m
//  SpringSort
//
//  Created by Eric Wolter on 12.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SpringBoardView.h"


@implementation SpringBoardView

@synthesize image;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
	self.image = nil;
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor blueColor] set];
	NSRectFill(dirtyRect);
	
	if(image)
	{
		[image drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0f];
	}
}

@end
