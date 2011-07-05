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
#import "SbPage.h"
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

static NSBezierPath *excludedPath, *boxPath, *arrowPath;

static NSColor *pageBackgroundColor, *pageBorderColor, *pageSeperatorColor;
@interface SpringBoardView()
-(void)drawSbPage:(SbPage *)page inRect:(NSRect)rect;
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
	
	excludedPath = [[NSBezierPath alloc] init];
	float leftBottomX = 30;
	float leftBottomY = leftBottomX;
	float rightTopX = leftBottomX * 2;
	float rightTopY = rightTopX;
	[excludedPath moveToPoint: NSMakePoint(leftBottomX, leftBottomY)];
	[excludedPath lineToPoint: NSMakePoint(leftBottomX + rightTopX, leftBottomY + rightTopY)];
	[excludedPath moveToPoint: NSMakePoint(leftBottomX, leftBottomY + rightTopY)];
	[excludedPath lineToPoint: NSMakePoint(leftBottomX + rightTopX, leftBottomY)];
	[excludedPath appendBezierPathWithOvalInRect:NSMakeRect(0.0, 0.0, rightTopX * 2, rightTopY * 2)];
	
	boxPath = [[NSBezierPath alloc] init];
	float boxHeight = 50.0;
	float boxWidth = 100.0;
	[boxPath moveToPoint: NSMakePoint(0.0, boxHeight)];
	[boxPath lineToPoint: NSMakePoint(0.0, 0.0)];
	[boxPath lineToPoint: NSMakePoint(boxWidth, 0.0)];
	[boxPath lineToPoint: NSMakePoint(boxWidth, boxHeight)];
	
	arrowPath = [[NSBezierPath alloc] init];
	float arrowHeadHeight = 35.0;
	float arrowHeadWidth = 70.0;
	float arrowBodyWidth = 30.0;
	float arrowHeadOverlap = (arrowHeadWidth - arrowBodyWidth)/2.0;
	float arrowBodyHeight = 45.0;
	[arrowPath moveToPoint:NSMakePoint(0.0, arrowHeadHeight)];
	[arrowPath lineToPoint:NSMakePoint(arrowHeadWidth/2.0, 0.0)];
	[arrowPath lineToPoint:NSMakePoint(arrowHeadWidth, arrowHeadHeight)];
	[arrowPath lineToPoint:NSMakePoint(arrowHeadWidth-arrowHeadOverlap, arrowHeadHeight)];
	[arrowPath lineToPoint:NSMakePoint(arrowHeadWidth-arrowHeadOverlap, arrowHeadHeight+arrowBodyHeight)];
	[arrowPath lineToPoint:NSMakePoint(arrowHeadOverlap, arrowHeadHeight+arrowBodyHeight)];
	[arrowPath lineToPoint:NSMakePoint(arrowHeadOverlap, arrowHeadHeight)];
	[arrowPath closePath];
	
	NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle alloc] init];
	[textStyle setAlignment:NSCenterTextAlignment];
	[textStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];
	NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithObject:textStyle forKey:NSParagraphStyleAttributeName];
	[textStyle release];
	NSFont* font= [NSFont fontWithName:@"Helvetica Neue" size:11.0];
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowColor:[NSColor colorWithCalibratedWhite:1.0f alpha:0.75f]];
	[shadow setShadowBlurRadius:3.0f];
	[shadow setShadowOffset:NSMakeSize(2.0f,-2.0f)]; 
	[attr setObject:shadow forKey:NSShadowAttributeName];
	[shadow release];
	[attr setObject:font forKey:NSFontAttributeName];
	[attr setObject:[NSColor colorWithCalibratedRed:76.0f/255.0f green:76.0f/255.0f blue:76.0f/255.0f alpha:1.0f] forKey:NSForegroundColorAttributeName];
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

- (void) drawSpecialPageStateIsTargetOnlyFor: (NSRect)pageRect
{
	[[NSColor colorWithCalibratedWhite:0.0f alpha:0.5f] set];
	[NSBezierPath fillRect: pageRect];

	[[NSColor colorWithCalibratedWhite:1.0f alpha:0.5f] set];
	NSAffineTransform *centerBox = [NSAffineTransform transform];
	[centerBox translateXBy:pageRect.origin.x + pageRect.size.width/2.0f - [boxPath bounds].size.width/2.0f yBy:pageRect.origin.y + pageRect.size.height/2.0f - [boxPath bounds].size.height/2.0f - 20];
	
	NSBezierPath *drawBox = [centerBox transformBezierPath:boxPath];
	[drawBox setLineJoinStyle:NSRoundLineJoinStyle];
	[drawBox setLineWidth:20];
	[drawBox stroke];
	
	NSAffineTransform *centerArrow = [NSAffineTransform transform];
	[centerArrow translateXBy:pageRect.origin.x + pageRect.size.width/2.0f - [arrowPath bounds].size.width/2.0f yBy:pageRect.origin.y + pageRect.size.height/2.0f - [arrowPath bounds].size.height/2.0f + 20];
	
	NSBezierPath *drawArrow = [centerArrow transformBezierPath:arrowPath];
	[drawArrow fill];
}

- (void) drawSpecialPageStateIsExcludedFor: (NSRect)pageRect
{
	[[NSColor colorWithCalibratedWhite:0.0f alpha:0.75f] set];
	[NSBezierPath fillRect: pageRect];
	
	[[NSColor colorWithCalibratedWhite:1.0f alpha:0.5f] set];
	
	NSAffineTransform *centerExcluded = [NSAffineTransform transform];
	[centerExcluded translateXBy:pageRect.origin.x + pageRect.size.width/2.0f - [excludedPath bounds].size.width/2.0f yBy:pageRect.origin.y + pageRect.size.height/2.0f - [excludedPath bounds].size.height/2.0f];
	NSBezierPath *drawExcluded = [centerExcluded transformBezierPath:excludedPath];
	[drawExcluded setLineWidth:20];
	[drawExcluded stroke];
}

- (void)drawRect:(NSRect)dirtyRect
{	
	[backgroundColor set];
	NSRectFill(self.frame);
	
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
	}
}

-(void)drawSbPage:(SbPage *)page inRect:(NSRect)rect
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
	
	if(page.state != PageIsIncluded) {
		switch (page.state) {
			case PageIsExcluded:
				[self drawSpecialPageStateIsExcludedFor:rect];
				break;
			case PageIsTargetOnly:
				[self drawSpecialPageStateIsTargetOnlyFor:rect];
				break;
			default:
				break;
		}
	}
}

-(void)drawSbIcon:(SbIcon *)icon inRect:(NSRect)rect
{
	[icon.icon drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
	[icon.displayName drawInRect:NSMakeRect(rect.origin.x-10, rect.origin.y-20, rect.size.width+20, 20) withAttributes:textStyleAttributes];
}

-(void)drawSbFolder:(SbFolder *)folder inRect:(NSRect)rect
{
	[folderBackground drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
	
	[folder.displayName drawInRect:NSMakeRect(rect.origin.x-10, rect.origin.y-20, rect.size.width+20, 20) withAttributes:textStyleAttributes];
	
	CGFloat borderX = 7.5;
	CGFloat offsetX = rect.origin.x + borderX;
	CGFloat offsetY = 19;
	
	offsetY = offsetY - folderIconHeight - folderIconGapHeight;
	
	int count = 0;
	for (SbIcon *icon in [[folder.items objectAtIndex:0] items]) {
		if (count % 3 == 0) {
			offsetY = offsetY + folderIconWidth + folderIconGapHeight;
			offsetX = rect.origin.x + borderX;
		}
		
		NSRect folderItemRect = NSMakeRect(offsetX, rect.origin.y + (59 - offsetY), folderIconWidth, folderIconHeight);
		[icon.icon drawInRect:folderItemRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
		
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
