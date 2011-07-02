//
//  SortingByGenre.m
//  SpringSort
//
//  Created by Eric Wolter on 07.05.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SortingByGenre.h"
#import "Utilities.h"

@implementation SortingByGenre

static NSInteger Genre_Alphabet_Comparer(id id1, id id2, void *context)
{
	SbIcon *icon1 = (SbIcon *)id1;
	SbIcon *icon2 = (SbIcon *)id2;
	
	NSComparisonResult genreCompare = [icon1.primaryGenre localizedCaseInsensitiveCompare:icon2.primaryGenre];
	
	if(genreCompare != NSOrderedSame) {
		return genreCompare;
	} else {
		return [icon1.displayName localizedCaseInsensitiveCompare:icon2.displayName];
	}
}

-(NSArray *)sort:(NSArray *)icons
{
	return [icons sortedArrayUsingFunction:Genre_Alphabet_Comparer context:nil];
}

@end
