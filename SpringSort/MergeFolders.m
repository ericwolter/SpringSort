//
//  MergeFolders.m
//  SpringSort
//
//  Created by Eric Wolter on 03.07.11.
//  Copyright 2011 private. All rights reserved.
//

#import "MergeFolders.h"
#import "SbPage.h"
#import "SbFolder.h"

@implementation MergeFolders

-(SbFolder *)mergeFolders:(NSArray *)folders
{
	SbFolder *mergedFolder = [[SbFolder alloc] init];
	mergedFolder.displayName = [[folders objectAtIndex:0] displayName];
	SbContainer *mergedFolderContent = [[SbContainer alloc] init];
	[mergedFolder.items addObject:mergedFolderContent];
	for (SbFolder *folder in folders) {
		SbContainer *folderContent = [folder.items objectAtIndex:0];
		[mergedFolderContent.items addObjectsFromArray:folderContent.items];
	}
	
	NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"displayName"
                                                  ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	[mergedFolderContent.items sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	return [mergedFolder autorelease];
}

-(NSArray *)merge:(NSArray *)items into:(NSArray *)pages
{
	NSMutableArray *leftovers = [[NSMutableArray alloc] init];
	
	for (id newItem in items) {
		if([newItem isKindOfClass:[SbFolder class]]) {
			SbFolder *newFolder = (SbFolder *)newItem;
			SbPage *firstPage = nil;
			NSUInteger firstIndex = 0;
			NSMutableArray *matches = [[NSMutableArray alloc] init];
			for (SbPage *page in pages) {
				for (NSUInteger i = 0; i < [page.items count]; ++i) {
					id oldItem = [page.items objectAtIndex:i];
					if ([oldItem isKindOfClass:[SbFolder class]]) {
						SbFolder *oldFolder = (SbFolder *)oldItem;
						if([newFolder.displayName isEqualToString:oldFolder.displayName]) {
							if (firstPage == nil) {
								firstPage = page;
								firstIndex = i;
							}
							[matches addObject:oldFolder];
							[page.items removeObjectAtIndex:i];
							i = i - 1;
						}
					}
				}
			}
			if ([matches count] > 0) {
				[matches addObject:newFolder];
				[firstPage.items insertObject:[self mergeFolders:matches] atIndex:firstIndex];
			} else {
				[leftovers addObject:newFolder];
			}
			[matches release];
		} else {
			[leftovers addObject:newItem];
		}
	}
	
	SbPage *newPage = [[SbPage alloc] init];
	[newPage.items addObjectsFromArray:leftovers];
	
	return [NSArray arrayWithObject:newPage];
}

@end
