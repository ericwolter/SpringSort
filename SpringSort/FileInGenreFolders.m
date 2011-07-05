//
//  OrganizingByGenreFolder.m
//  SpringSort
//
//  Created by Eric Wolter on 02.07.11.
//  Copyright 2011 private. All rights reserved.
//

#import "FileInGenreFolders.h"
#import "SbContainer.h"
#import "SbFolder.h"
#import "SbIcon.h"

@implementation FileInGenreFolders

-(NSArray *)file:(NSArray *)icons
{
	NSMutableArray *organized = [[NSMutableArray alloc] init];
	
	NSString *currentGenre = @"";
	SbContainer *currentFolderContent;
	for(SbIcon *icon in icons)
	{
		if(![icon.primaryGenre isEqualToString:currentGenre]) {
			currentGenre = icon.primaryGenre;
			SbFolder *folder = [[SbFolder alloc] init];
			folder.displayName = currentGenre;
			currentFolderContent = [[SbContainer alloc] init];
			[folder.items addObject:currentFolderContent];
			[organized addObject:folder];
			[currentFolderContent release];
			[folder release];
		}
		
		[currentFolderContent.items addObject:icon];

	}
	
	return organized;
}


@end
