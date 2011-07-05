//
//  SbPage.m
//  SpringSort
//
//  Created by Eric Wolter on 02.07.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SbPage.h"
#import "Utilities.h"

@implementation SbPage

@synthesize state;

+(id)newFromPlist:(plist_t)thePlist
{
	SbPage *newPage = [[SbPage alloc] init];
	
	if(newPage) {
		int count = plist_array_get_size(thePlist);
		for (int i = 0; i < count; i++) 
		{
			[newPage.items addObject:[Utilities switchSbType:plist_array_get_item(thePlist, i)]];
		}
	}
	
	return newPage;
}

- (id)init
{
    self = [super init];
    if (self) {
		self.state = PageIsIncluded;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(id)copy
{
	SbPage *newPage = [[SbPage alloc] init];
	NSMutableArray *newItems = [[NSMutableArray alloc] initWithArray:self.items copyItems:YES];
	newPage.items = newItems;
	[newItems release];
	newPage.state = self.state;
	return newPage;
}

@end
