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
	return nil;
}

-(NSMutableArray *)retouch:(NSArray *)unretouched
{
	NSMutableArray *retouched = [NSMutableArray array];
	
	for (SbPage *page in unretouched) {
		for (NSUInteger i = 0; i < [page.items count]; ++i) {
			SbFolder *folder = [page.items objectAtIndex:i];
			if(folder.count > 12) {
				NSArray *splitted = [self splitFolder:folder];
				[page.items replaceObjectsAtIndexes:[NSIndexSet indexSetWithIndex:i] withObjects:splitted];
				i = i + [splitted count] - 1;
			}
		}
	}
	
	return retouched;
}

@end
