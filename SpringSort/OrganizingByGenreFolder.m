//
//  OrganizingByGenreFolder.m
//  SpringSort
//
//  Created by Eric Wolter on 02.07.11.
//  Copyright 2011 private. All rights reserved.
//

#import "OrganizingByGenreFolder.h"
#import "SbContainer.h"
#import "SbFolder.h"
#import "SbIcon.h"

@implementation OrganizingByGenreFolder

-(NSArray *)file:(NSArray *)icons
{
	NSMutableArray *organized = [[NSMutableArray alloc] init];
	
	NSString *currentGenre;
	SbContainer *currentFolderContent;
	for(SbIcon *icon in icons)
	{
		if([icon.primaryGenre isEqualToString:currentGenre]) {
			[currentFolderContent.items addObject:icon];
		} else {
			currentGenre = icon.primaryGenre;
			SbFolder *folder = [[SbFolder alloc] init];
			folder.displayName = currentGenre;
			currentFolderContent = [[SbContainer alloc] init];
			[folder.items addObject:currentFolderContent];
			[organized addObject:folder];
			[currentFolderContent release];
			[folder release];
		}
	}
	
	return organized;
}


@end
