#import "MyScroller.h"

static NSColor *backgroundColor;
static NSImage *knobLeft, *knobHorizontalFill, *knobRight;

@implementation MyScroller

+ (void)initialize
{
	NSBundle *bundle = [NSBundle bundleForClass:[MyScroller class]];

	// Horizontal scroller
	knobLeft			= [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"ScrollerKnobLeft.png"]];
	knobHorizontalFill	= [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"ScrollerHorizontalFill.png"]];
	knobRight			= [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"ScrollerKnobRight.png"]];
	
	NSImage *bgImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"SpringBoardViewBackground.png"]];
	backgroundColor		= [[NSColor colorWithPatternImage:bgImage] retain];
	[bgImage release];
}

- (void)drawRect:(NSRect)aRect;
{
	[backgroundColor set];
	NSRectFill([self bounds]);
	
	if ([self knobProportion] >  0.0)	
		[self drawKnob];
}

- (void)drawKnob;
{
	NSRect knobRect = [self rectForPart:NSScrollerKnob];
	knobRect.size.height -= 7;
	knobRect.origin.y += 4;
	
	NSDrawThreePartImage(knobRect, knobLeft, knobHorizontalFill, knobRight, NO, NSCompositeSourceOver, 1, NO);
}

@end
