//
//  SortingByGenre.m
//  SpringSort
//
//  Created by Eric Wolter on 07.05.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SortingByGenre.h"
#import "Utilities.h"
#import "SortingByAlphabet.h"

@implementation SortingByGenre

- (id)initWithController:(SpringSortController *)theController;
{
    self = [super initWithController:theController];
    if (self) {
		self.name = @"ByGenre";
		self.description = @"Sorts by Genre";
    }
    
    return self;
}

-(SbState *)newSortedState:(SbState *)sourceState
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
	
	NSMutableDictionary *byGenre = [[NSMutableDictionary alloc] init];
	for (SbIcon *icon in flatten) {
		NSArray *genres = [self.controller getGenresforIcon:icon];
		NSNumber *primaryGenre = [genres count] > 0 ? [genres objectAtIndex:0] : @"Uncategorized";
		NSMutableArray *genreArray = [byGenre objectForKey:primaryGenre];
		if (!genreArray) {
			genreArray = [NSMutableArray array];
			[byGenre setObject:genreArray forKey:primaryGenre];
		}
		[genreArray addObject:icon];
	}
	[flatten release];
	
	NSMutableArray *result = [NSMutableArray array];
	
	for (NSString *genre in [byGenre allKeys]) {
		NSArray *sorted = [self sortByDisplayName:[byGenre objectForKey:genre]];
		
		int count = 0;
		SbContainer *folderContent;
		for (SbIcon *icon in sorted) {
			if (count % 12 == 0) {
				SbFolder *folder = [[SbFolder alloc] init];
				folder.displayName = [NSString stringWithFormat:
									  @"%@ %@",
									  genre,
									  count == 0 ? @"" : [NSString stringWithFormat:@"%i", (count/12)+1]];
				folderContent = [[SbContainer alloc] init];
				[folder.items addObject:folderContent];
				[result addObject:folder];
				[folderContent release];
				[folder release];
			}
			[folderContent.items addObject:icon];
			count++;
		}
	}
	[byGenre release];
	
	int count = 0;
    SbContainer *page;
    for (id item in [self sortByDisplayName:result]) {
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
