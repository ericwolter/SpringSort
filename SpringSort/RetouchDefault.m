//
//  RetouchDefault.m
//  SpringSort
//
//  Created by Eric Wolter on 02.07.11.
//  Copyright 2011 private. All rights reserved.
//

#import "RetouchDefault.h"
#import "SbPage.h"
#import "SbFolder.h"

@implementation RetouchDefault

-(NSArray *)splitFolder:(SbFolder *)folder
{
	NSMutableArray* splitFolders = [[NSMutableArray alloc] init];
	SbContainer *folderContent = [folder.items objectAtIndex:0];
	
	NSUInteger size = 12;
	NSUInteger total = [folderContent.items count];
	for (NSUInteger i = 0; i < total; i = i + size) {
		NSUInteger length = size;
		if (i + length > total) {
			length = total - i;
		}
		
		SbFolder *newFolder = [[SbFolder alloc] init];
		newFolder.displayName = folder.displayName;
		SbContainer *newFolderContent = [[SbContainer alloc] init];
		[newFolderContent.items addObjectsFromArray:[folderContent.items subarrayWithRange:NSMakeRange(i, length)]];
		[newFolder.items addObject:newFolderContent];
		[splitFolders addObject:newFolder];
	}
	
	return [splitFolders autorelease];
}

-(NSArray *)splitPage:(SbPage *)page
{
	NSMutableArray *splitPages = [[NSMutableArray alloc] init];
	
	NSUInteger size = 16;
	NSUInteger total = [page.items count];
	for (NSUInteger i = 0; i < total; i = i + size) {
		NSUInteger length = size;
		if(i + length > total) {
			length = total - i;
		}
		
		SbPage *newPage = [[SbPage alloc] init];
		[newPage.items addObjectsFromArray:[page.items subarrayWithRange:NSMakeRange(i, length)]];
		[splitPages addObject:newPage];
	}
	
	return [splitPages autorelease];
}

-(NSMutableArray *)retouch:(NSArray *)unretouched
{
	NSMutableArray *retouched = [NSMutableArray array];
	
	for (SbPage *page in unretouched) {
		for (NSUInteger i = 0; i < [page.items count]; ++i) {
			id item = [page.items objectAtIndex:i];
			if([item isKindOfClass:[SbFolder class]]) {
				SbFolder *folder = (SbFolder *)item;
				if(folder.count > 12) {
					NSArray *splittedFolder = [self splitFolder:folder];
					[page.items replaceObjectsInRange:NSMakeRange(i, 1) withObjectsFromArray:splittedFolder];
					i = i + [splittedFolder count] - 1;
				}				
			}
		}
		
		if([page.items count] > 16) {
			NSArray *splittedPages = [self splitPage:page];
			[retouched addObjectsFromArray:splittedPages];
		} else if ([page.items count] > 0) {
			[retouched addObject:page];
		}
	}
	
	return retouched;
}

@end
