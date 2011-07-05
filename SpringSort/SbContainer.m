//
//  SbFolder.m
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SbContainer.h"
#import "Utilities.h"

@implementation SbContainer

@synthesize items;

+(id)newFromPlist:(plist_t)thePlist
{
	SbContainer *newContainer = [[SbContainer alloc] init];
	
	if(newContainer) {
		int count = plist_array_get_size(thePlist);
		for (int i = 0; i < count; i++) 
		{
			[newContainer.items addObject:[Utilities switchSbType:plist_array_get_item(thePlist, i)]];
		}
	}
	
	return newContainer;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        self.items = [[NSMutableArray alloc] init];
    }
    return self;    
}

-(void)dealloc
{
    self.items = nil;
    [super dealloc];
}

-(id)copy
{
	SbContainer *newContainer = [[SbContainer alloc] init];
	NSMutableArray *newItems = [[NSMutableArray alloc] initWithArray:self.items copyItems:YES];
	newContainer.items = newItems;
	[newItems release];
	return newContainer;
}

-(plist_t)toPlist
{
    plist_t pContainer = plist_new_array();
    for (id item in self.items)
    {
        plist_array_append_item(pContainer, [item toPlist]);
    }
    return pContainer;
}

@end
