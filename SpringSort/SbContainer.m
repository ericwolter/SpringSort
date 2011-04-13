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

-(id)initFromPlist:(plist_t)plist
{
    self = [super init];
    if (self)
    {
		self.items = [NSMutableArray array];
		
		int count = plist_array_get_size(plist);
		for (int i = 0; i < count; i++)
		{
			[self.items addObject:[Utilities switchSbType:plist_array_get_item(plist, i)]];
		}
    }
    return self;    
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
