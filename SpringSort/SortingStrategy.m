//
//  SortingStrategy.m
//  SpringSort
//
//  Created by Eric Wolter on 07.05.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SortingStrategy.h"

@implementation SortingStrategy

@synthesize name, description;
@synthesize controller;

- (id)initWithController:(SpringSortController *)theController;
{
    self = [super init];
    if (self) {
		self.controller = theController;
    }
    
    return self;
}

- (void)dealloc
{
	[name release];
	[description release];
    [super dealloc];
}

- (SbState *)newSortedState:(SbState *)sourceState { return nil; }

- (NSArray *)sortByDisplayName:(NSArray *)array
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"displayName"
                                                  ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	return [array sortedArrayUsingDescriptors:sortDescriptors];
}

@end
