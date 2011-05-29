//
//  MySidebarButtonCell.m
//  SpringSort
//
//  Created by Eric Wolter on 25.05.11.
//  Copyright 2011 private. All rights reserved.
//

#import "MySidebarButtonCell.h"

static NSImage *highlight;
static NSDictionary *titleStyle;
static NSDictionary *descriptionStyle;

@implementation MySidebarButtonCell

+ (void)initialize
{
	NSBundle *bundle = [NSBundle bundleForClass:[MySidebarButtonCell class]];
	
	highlight = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"SidebarButtonHighlight.png"]];
	
	NSMutableDictionary *titleAttr = [[NSMutableDictionary alloc] init];
	NSFont *titleFont = [[NSFontManager sharedFontManager] fontWithFamily:@"Helvetica Neue" traits:NSBoldFontMask weight:0 size:11];
	[titleAttr setObject:titleFont forKey:NSFontAttributeName];
	[titleAttr setObject:[NSColor colorWithCalibratedRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f] forKey:NSForegroundColorAttributeName];
	titleStyle = titleAttr;
	
	NSMutableDictionary *descriptionAttr = [[NSMutableDictionary alloc] init];
	NSMutableParagraphStyle *descriptionParagraph = [[NSMutableParagraphStyle alloc] init];
	[descriptionParagraph setLineSpacing:-5.0f];
	[descriptionAttr setObject:descriptionParagraph forKey:NSParagraphStyleAttributeName];
	[descriptionParagraph release];
	NSFont *descriptionFont = [NSFont fontWithName:@"Helvetica Neue" size:11];
	[descriptionAttr setObject:descriptionFont forKey:NSFontAttributeName];
	[descriptionAttr setObject:[NSColor colorWithCalibratedRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f] forKey:NSForegroundColorAttributeName];
	descriptionStyle = descriptionAttr;
}

-(void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
	[[NSColor whiteColor] set];
	NSRectFill(frame);
	
	if([self isHighlighted]) {
		[highlight drawInRect:NSMakeRect(0.0f, 0.0f, 319.0f, 59.0f) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
	}				
}

-(NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
	NSButton *parent = (NSButton *)controlView;
	NSRect titleRect = NSMakeRect(10.0f, 5.0f, frame.size.width - 20.0f, 20.0f);
	NSRect descriptionRect = NSMakeRect(10.0f, 22.0f, frame.size.width - 20.0f, 40.0f);
	[[parent title] drawInRect:titleRect withAttributes:titleStyle];
	[[parent alternateTitle] drawInRect:descriptionRect withAttributes:descriptionStyle];
	return NSUnionRect(titleRect, descriptionRect);
}

@end
