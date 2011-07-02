//
//  SortingWorkflow.h
//  SpringSort
//
//  Created by Eric Wolter on 02.07.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrepareStep.h"
#import	"SortStep.h"
#import	"FileStep.h"
#import "MergeStep.h"
#import "RetouchStep.h"
#import "SbState.h"

@interface SortingWorkflow : NSObject {
@private
	id<PrepareStep> prepareStep;
	id<SortStep> sortStep;
	id<FileStep> fileStep;
	id<MergeStep> mergeStep;
	id<RetouchStep> retouchStep;
}

- (id)initWithSteps:(NSArray *)steps;
-(SbState *)newSortedState:(SbState *)state;

@end
