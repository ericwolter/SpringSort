//
//  PrepareFlat.m
//  SpringSort
//
//  Created by Eric Wolter on 03.07.11.
//  Copyright 2011 private. All rights reserved.
//

#import "PrepareFlat.h"
#import "SbPage.h"
#import "SbIcon.h"
#import "SbFolder.h"
#import "Utilities.h"

@implementation PrepareFlat

-(NSArray *)prepare:(NSArray *)pages
{
	NSMutableArray *prepared = [[NSMutableArray alloc] init];
	for (SbPage *page in pages) {
		[Utilities flatten:page IntoArray:prepared];
	}
	
	return prepared;
}

@end
