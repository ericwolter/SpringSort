//
//  SortingByAlphabet.m
//  SpringSort
//
//  Created by Eric Wolter on 07.05.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SortingByAlphabet.h"
#import "Utilities.h"

@implementation SortingByAlphabet

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (SbState *)newSortedState:(SbState *)sourceState
{
	SbState *newState = [[SbState alloc] init];
	
	NSMutableArray *flatten = [[NSMutableArray alloc] init];
	int pageIndex = 0;
	for (SbContainer *pageContainer in sourceState.mainContainer.items) {
		if([self.controller isPageIgnored:pageIndex]) {
			[newState.mainContainer.items addObject:[pageContainer copy]];
		} else {
			[Utilities flatten:pageContainer IntoArray:flatten];
		}
		pageIndex++;
	}
	
	int count = 0;
    SbContainer *page;
    for (id item in [self sortByDisplayName:flatten]) {
        if (count % 16 == 0)
        {
            page = [[SbContainer alloc] init];
            [newState.mainContainer.items addObject:page];
            [page release];
        }
        [page.items addObject:item];
        count++;
    }
	
	return newState;
}

@end
