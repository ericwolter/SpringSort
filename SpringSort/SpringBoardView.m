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

static NSColor *backgroundColor;
static NSImage *folderBackground;
static NSDictionary *textStyleAttributes;

static CGFloat pageWidth = 320;
static CGFloat pageHeight = 377;

static CGFloat iconWidth = 59;
static CGFloat iconHeight = 62;
static CGFloat iconGapWidth = 17;
static CGFloat iconGapHeight = 29;

static CGFloat folderIconWidth = 12.5;
static CGFloat folderIconHeight = 12.5;
static CGFloat folderIconGapWidth = 3.5;
static CGFloat folderIconGapHeight = 3.5;

static NSColor *pageBackgroundColor, *pageBorderColor, *pageSeperatorColor;
@interface SpringBoardView()
-(void)drawSbPage:(SbContainer *)page inRect:(NSRect)rect;
-(void)drawSbIcon:(SbIcon *)icon inRect:(NSRect)rect;
-(void)drawSbFolder:(SbFolder *)folder inRect:(NSRect)rect;
@end

@implementation SpringBoardView

@synthesize controller;
@synthesize state;

+ (void)initialize
{
	[super initialize];
	
	NSBundle *bundle = [NSBundle bundleForClass:[SpringBoardView class]];
	
	NSImage *bgImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"SpringBoardViewBackground.png"]];
	backgroundColor = [[NSColor colorWithPatternImage:bgImage] retain];
	[bgImage release];
	
	folderBackground = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"FolderIconBg.png"]];
	
	NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle alloc] init];
	[textStyle setAlignment:NSCenterTextAlignment];
	[textStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];
	NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithObject:textStyle forKey:NSParagraphStyleAttributeName];
	[textStyle release];
	NSFontManager *fontManager = [NSFontManager sharedFontManager];
	NSFont *font = [fontManager fontWithFamily:@"Helvetica Neue" traits:NSBoldFontMask weight:0 size:11];
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowColor:[NSColor blackColor]];
	[shadow setShadowBlurRadius:3.0f];
	[shadow setShadowOffset:NSMakeSize(0.0f,-2.0f)]; 
	[attr setObject:shadow forKey:NSShadowAttributeName];
	[shadow release];
	[attr setObject:font forKey:NSFontAttributeName];
	[attr setObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	textStyleAttributes = [attr retain];
	
	pageBackgroundColor = [[NSColor colorWithCalibratedRed:62.0f/255.0f green:62.0f/255.0f blue:62.0f/255.0f alpha:1.0f] retain];
	pageBorderColor = [[NSColor colorWithCalibratedRed:76.0f/255.0f green:76.0f/255.0f blue:76.0f/255.0f alpha:1.0f] retain];
	pageSeperatorColor = [[NSColor colorWithCalibratedRed:42.0f/255.0f green:42.0f/255.0f blue:42.0f/255.0f alpha:1.0f] retain];
//	pageHeight = 16 + 4 * (iconHeight + iconGapHeight);
}

- (void)dealloc
{
	self.controller = nil;
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{	
	[backgroundColor set];
	NSRectFill(self.frame);
	
	if(!controller)
		return;
	
	if(!state)
		return;
	
	NSUInteger count = [self.state.mainContainer.items count];
	// count also includes the dock so we ignore it
	CGFloat frameWidth = (count-1)*pageWidth+count;
	pageHeight = [self frame].size.height;
	[self setFrameSize:NSMakeSize(frameWidth, pageHeight)];
	[backgroundColor set];
	NSRectFill(self.frame);
	
	int i = 0;
	for (i = 1; i < count; i++) {
		NSRect pageRect = NSMakeRect((i-1) * pageWidth, 0, pageWidth, pageHeight);
		[self drawSbPage:[self.state.mainContainer.items objectAtIndex:i] inRect:pageRect];

		switch ([controller getPageState:i]) {
			case PageIsExcluded:
				[[NSColor colorWithCalibratedWhite:0.0f alpha:0.75f] set];
				[NSBezierPath fillRect: pageRect];
				[[NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.5f] set];
				NSBezierPath *circle1 = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(((i-1) * 320) + 320.0f/2.0f - 15, pageHeight/2.0f - 15, 30, 30)];
				[circle1 setLineWidth:100];
				[circle1 stroke];
				break;
			case PageIsTargetOnly:
				[[NSColor colorWithCalibratedWhite:0.0f alpha:0.75f] set];
				[NSBezierPath fillRect: pageRect];
				[[NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.5f] set];
				NSBezierPath *circle2 = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(((i-1) * 320) + 320.0f/2.0f - 15, pageHeight/2.0f - 15, 30, 30)];
				[circle2 setLineWidth:100];
				[circle2 stroke];
				break;
			default:
				break;
		}
	}
}

-(void)drawSbPage:(SbContainer *)page inRect:(NSRect)rect
{
	CGFloat borderX = 16;
	CGFloat offsetX = rect.origin.x + borderX;
	CGFloat offsetY = rect.origin.y + borderX;
	
	offsetY = offsetY - iconHeight - iconGapHeight;
	
	int count = 0;
	for (id item in page.items)
	{
		if (count % 4 == 0) {
			offsetY = offsetY + iconHeight + iconGapHeight;
			offsetX = rect.origin.x + borderX;
		}
		if([item isKindOfClass:[SbIcon class]]) {
			[self drawSbIcon:item inRect:NSMakeRect(offsetX, pageHeight-offsetY-iconHeight, iconWidth, iconHeight)];
		} else {
			[self drawSbFolder:item inRect:NSMakeRect(offsetX, pageHeight-offsetY-iconHeight, 59, 59)];
		}
		offsetX = offsetX + iconWidth + iconGapWidth;
		
		count++;
	}
}

-(void)drawSbIcon:(SbIcon *)icon inRect:(NSRect)rect
{
	NSImage *image = [controller getImageForIcon:icon];
	[image drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
	[icon.displayName drawInRect:NSMakeRect(rect.origin.x-10, rect.origin.y-16, rect.size.width+20, 20) withAttributes:textStyleAttributes];
}

-(void)drawSbFolder:(SbFolder *)folder inRect:(NSRect)rect
{
	[folderBackground drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
	
	[folder.displayName drawInRect:NSMakeRect(rect.origin.x-10, rect.origin.y-16, rect.size.width+20, 20) withAttributes:textStyleAttributes];
	
	CGFloat borderX = 7.5;
	CGFloat offsetX = rect.origin.x + borderX;
	CGFloat offsetY = 19;
	
	offsetY = offsetY - folderIconHeight - folderIconGapHeight;
	
	int count = 0;
	for (id icon in [[folder.items objectAtIndex:0] items]) {
		if (count % 3 == 0) {
			offsetY = offsetY + folderIconWidth + folderIconGapHeight;
			offsetX = rect.origin.x + borderX;
		}
		
		NSImage *image = [controller getImageForIcon:icon];
		NSRect folderItemRect = NSMakeRect(offsetX, rect.origin.y + (59 - offsetY), folderIconWidth, folderIconHeight);
		[image drawInRect:folderItemRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];

		offsetX = offsetX + folderIconWidth + folderIconGapWidth;
		
		count++;
		
		if (count > 8) {
			break;
		}
	}
}

-(void)mouseUp:(NSEvent *)theEvent
{
	NSPoint clickPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	[controller togglePageState:(int)(clickPoint.x / pageWidth) + 1];
	[self display];
}

@end
