//
//  SortingWorkflow.m
//  SpringSort
//
//  Created by Eric Wolter on 02.07.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SortingWorkflow.h"
#import "SbContainer.h"
#import "SbPage.h"

@implementation SortingWorkflow

- (id)initWithSteps:(NSArray *)steps
{
    self = [super init];
    if (self) {
		if ([steps count] == 5) {
			prepareStep = [[steps objectAtIndex:0] retain];
			sortStep = [[steps objectAtIndex:1] retain];
			fileStep = [[steps objectAtIndex:2] retain];
			mergeStep = [[steps objectAtIndex:3] retain];
			retouchStep = [[steps objectAtIndex:4] retain];
		} else {
			return nil;
		}
    }
    
    return self;	
}

- (void)dealloc
{
	[prepareStep release];
	[sortStep release];
	[fileStep release];
	[mergeStep release];
	[retouchStep release];
    [super dealloc];
}

-(SbState *)newState
{
	SbState *newState = [[SbState alloc] init];
	SbContainer *newContainer = [[SbContainer alloc] init];
	newState.mainContainer = newContainer;
	[newContainer release];
	
	return newState;
}

-(SbState *)newSortedState:(SbState *)state
{
	SbState *newState = [self newState];
	
	NSMutableArray *clutteredPages = [NSMutableArray array];
	NSMutableArray *targets = [NSMutableArray array];
	for (SbPage *page in state.mainContainer.items) {
		SbPage *newPage = [page copy];
		switch (newPage.state) {
			case PageIsIncluded:
				[clutteredPages addObject:newPage];
				break;
			case PageIsExcluded:
				[newState.mainContainer.items addObject:newPage];
				break;
			case PageIsTargetOnly:
				[newState.mainContainer.items addObject:newPage];
				[targets addObject:newPage];
			default:
				break;
		}
	}
	
	NSArray *prepared = [prepareStep prepare:clutteredPages];
	NSArray *sorted = [sortStep sort:prepared];
	NSArray *filed = [fileStep file:sorted];
	NSArray *leftovers = [mergeStep merge:filed into:targets];
	[newState.mainContainer.items addObjectsFromArray:leftovers];
	NSMutableArray *retouched = [retouchStep retouch:newState.mainContainer.items];
	newState.mainContainer.items = retouched;
	
	return newState;
}

@end
