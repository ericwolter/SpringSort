//
//  SpringBoardView.m
//  SpringSort
//
//  Created by Eric Wolter on 12.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SpringBoardView.h"
#import "SpringSortController.h"

#import "SbState.h"
#import "SbContainer.h"
#import "SbIcon.h"

@interface SpringBoardView()
-(void)drawSbPage:(SbContainer *)page;
-(void)drawSbIcon:(SbIcon *)icon inRect:(NSRect)rect;
@end

@implementation SpringBoardView

@synthesize controller;

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
	self.controller = nil;
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor blackColor] set];
	NSRectFill(NSMakeRect(0, 0, 320, 480));
	
	if(!controller)
		return;
	
	[[controller getWallpaper] drawInRect:NSMakeRect(0, 0, 320, 480) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0f];
	
	[self drawSbPage:[controller.state.mainContainer.items objectAtIndex:1]];
}

-(void)drawSbPage:(SbContainer *)page
{
	int iconSize = 57;
	int offsetX = 17;
	int offsetY = 33;
	int gapX = 19;
	int gapY = 31;
	
	offsetY = offsetY - iconSize - gapY;
	
	int count = 0;
	for (id item in page.items)
	{
		if (count % 4 == 0) {
			offsetY = offsetY + iconSize + gapY;
			offsetX = 17;
		}
		if([item isKindOfClass:[SbIcon class]]) {
			[self drawSbIcon:item inRect:NSMakeRect(offsetX, 480-offsetY-iconSize, iconSize, iconSize)];
		}
		offsetX = offsetX + iconSize + gapX;
		
		count++;
	}
}

-(void)drawSbIcon:(SbIcon *)icon inRect:(NSRect)rect
{
	NSImage *image = [controller getImageForIcon:icon];
	[image drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
	
	NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
	[style setAlignment:NSCenterTextAlignment];
	NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName];
	NSFontManager *fontManager = [NSFontManager sharedFontManager];
	NSFont *font = [fontManager fontWithFamily:@"Helvetica Neue" traits:NSBoldFontMask weight:0 size:9];
	[attr setObject:font forKey:NSFontAttributeName];
	[attr setObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	[icon.displayName drawInRect:NSMakeRect(rect.origin.x, rect.origin.y-10, rect.size.width, 14) withAttributes:attr];
	[style release];	
}

@end
