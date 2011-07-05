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

-(NSArray *)merge:(NSArray *)items into:(NSArray *)pages
{
	NSMutableArray *leftovers = [[NSMutableArray alloc] init];
	
	for (id newItem in items) {
		if([newItem isKindOfClass:[SbFolder class]]) {
			SbFolder *newFolder = (SbFolder *)newItem;
			BOOL matched = NO;
			for (SbPage *page in pages) {
				if (matched) {
					break;
				} else {
					for (SbFolder *oldFolder in page.items) {
						if([newFolder.displayName isEqualToString:oldFolder.displayName]) {
							matched = YES;
							break;
						}
					}
				}
			}
			if(!matched) {
				[leftovers addObject:newFolder];
			}
		} else {
			[leftovers addObject:newItem];
		}
	}
	
	SbPage *newPage = [[SbPage alloc] init];
	[newPage.items addObjectsFromArray:leftovers];
	
	return [NSArray arrayWithObject:newPage];
}

@end
