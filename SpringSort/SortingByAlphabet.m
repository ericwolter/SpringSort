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

- (id)initWithController:(SpringSortController *)theController;
{
    self = [super initWithController:theController];
    if (self) {
		self.name = @"ByAlphabet";
		self.description = @"Sorts by Alphabet";
    }
    
    return self;
}

- (SbState *)newSortedState:(SbState *)sourceState
{
	SbState *newState = [[SbState alloc] init];
	
	NSMutableArray *flatten = [[NSMutableArray alloc] init];
	int pageIndex = 0;
	for (SbContainer *pageContainer in sourceState.mainContainer.items) {
		if([self.controller getPageState:pageIndex]) {
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
