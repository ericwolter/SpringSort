//
//  MergeNothing.m
//  SpringSort
//
//  Created by Eric Wolter on 04.07.11.
//  Copyright 2011 private. All rights reserved.
//

#import "MergeNothing.h"
#import	"SbPage.h"

@implementation MergeNothing

-(NSArray *)merge:(NSArray *)items into:(NSArray *)pages
{
	SbPage *newPage = [[SbPage alloc] init];
	[newPage.items addObjectsFromArray:items];
	
	return [NSArray arrayWithObject:newPage];
}

@end
