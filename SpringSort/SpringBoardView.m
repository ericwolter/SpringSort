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
#import "SbFolder.h"
#import "SbIcon.h"

@interface SpringBoardView()
-(void)drawSbPage:(SbContainer *)page inRect:(NSRect)rect;
-(void)drawSbIcon:(SbIcon *)icon inRect:(NSRect)rect;
-(void)drawSbFolder:(SbFolder *)folder inRect:(NSRect)rect;
@end

@implementation SpringBoardView

@synthesize controller;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setFrameSize:NSMakeSize(320, 480)];
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
	if(!controller)
		return;
	
	NSUInteger count = [controller.state.mainContainer.items count];
	long width = (count - 1)*320 + (count-2)*10;
	[self setFrameSize:NSMakeSize(width, 480)];
	
	[[NSColor blackColor] set];
	NSRectFill(NSMakeRect(0, 0, width, 480));
	
	for (int i = 1; i < count; i++) {
		[self drawSbPage:[controller.state.mainContainer.items objectAtIndex:i] inRect:NSMakeRect((i-1) * 330, 0, 320, 480)];
	}
}

-(void)drawSbPage:(SbContainer *)page inRect:(NSRect)rect
{
	[[controller getWallpaper] drawInRect:rect fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0f];
	
	CGFloat iconSize = 59;
	CGFloat borderX = 16;
	CGFloat offsetX = rect.origin.x + borderX;
	CGFloat offsetY = rect.origin.y + 34;
	CGFloat gapX = 17;
	CGFloat gapY = 29;
	
	offsetY = offsetY - iconSize - gapY;
	
	int count = 0;
	for (id item in page.items)
	{
		if (count % 4 == 0) {
			offsetY = offsetY + iconSize + gapY;
			offsetX = rect.origin.x + borderX;
		}
		if([item isKindOfClass:[SbIcon class]]) {
			[self drawSbIcon:item inRect:NSMakeRect(offsetX, 480-offsetY-iconSize, iconSize, iconSize)];
		} else {
			[self drawSbFolder:item inRect:NSMakeRect(offsetX, 480-offsetY-iconSize, iconSize, iconSize)];
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
	NSFont *font = [fontManager fontWithFamily:@"Helvetica Neue" traits:NSBoldFontMask weight:0 size:11];
	[attr setObject:font forKey:NSFontAttributeName];
	[attr setObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	[icon.displayName drawInRect:NSMakeRect(rect.origin.x-10, rect.origin.y-16, rect.size.width+20, 20) withAttributes:attr];
	[style release];	
}

-(void)drawSbFolder:(SbFolder *)folder inRect:(NSRect)rect
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"FolderIconBg" ofType:@"png"];
	NSImage *folderBg = [[NSImage alloc] initWithContentsOfFile:path];
	[folderBg drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
	[folderBg release];
	
	NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
	[style setAlignment:NSCenterTextAlignment];
	NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName];
	NSFontManager *fontManager = [NSFontManager sharedFontManager];
	NSFont *font = [fontManager fontWithFamily:@"Helvetica Neue" traits:NSBoldFontMask weight:0 size:11];
	[attr setObject:font forKey:NSFontAttributeName];
	[attr setObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	[folder.displayName drawInRect:NSMakeRect(rect.origin.x-10, rect.origin.y-16, rect.size.width+20, 20) withAttributes:attr];
	[style release];	
	
	CGFloat iconSize = 12.5;
	CGFloat borderX = 7.5;
	CGFloat offsetX = rect.origin.x + borderX;
	CGFloat offsetY = 19;
	CGFloat gapX = 3.5;
	CGFloat gapY = 3.5;
	
	offsetY = offsetY - iconSize - gapY;
	
	int count = 0;
	for (id icon in [[folder.items objectAtIndex:0] items]) {
		if (count % 3 == 0) {
			offsetY = offsetY + iconSize + gapY;
			offsetX = rect.origin.x + borderX;
		}
		
		NSImage *image = [controller getImageForIcon:icon];
		NSRect folderItemRect = NSMakeRect(offsetX, rect.origin.y + (59 - offsetY), iconSize, iconSize);
		[image drawInRect:folderItemRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];

		offsetX = offsetX + iconSize + gapX;
		
		count++;
		
		if (count > 8) {
			break;
		}
	}
}

@end
