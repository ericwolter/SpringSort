//
//  SortingByAlphabet.m
//  SpringSort
//
//  Created by Eric Wolter on 07.05.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SortingByDisplayName.h"
#import "Utilities.h"

@implementation SortingByDisplayName

-(NSArray *)sort:(NSArray *)icons
{
	NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"displayName"
                                                  ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	return [icons sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

@end
