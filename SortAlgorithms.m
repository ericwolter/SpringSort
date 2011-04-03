//
//  SortAlgorithms.m
//  SpringSort
//
//  Created by Eric Wolter on 02.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SortAlgorithms.h"
#import "SbContainer.h"
#import "SbIcon.h"

@implementation SortAlgorithms

+(NSMutableArray *)alphabetically:(NSMutableArray *)pages
{
    NSMutableArray *flatten = [NSMutableArray array];
    
    int pageSize = [pages count];
    for (int pageIndex = 2; pageIndex < pageSize; pageIndex++)
    {
        SbContainer *page = [pages objectAtIndex:pageIndex];
        for (SbItem* item in page.items)
        {
            if([item isKindOfClass:[SbContainer class]])
            {   
                SbContainer *folder = (SbContainer *)item;
                for(SbIcon *icon in folder.items)
                {
                    [flatten addObject:icon];
                }
            }    
            else if([item isKindOfClass:[SbIcon class]])
            {
                [flatten addObject:item];
            }   
        }
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"displayName"
                                                  ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [flatten sortedArrayUsingDescriptors:sortDescriptors];
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[flatten count]+2];
    [result addObject:[pages objectAtIndex:0]];
    [result addObject:[pages objectAtIndex:1]];
    
    int count = 0;
    SbContainer *page;
    for (SbIcon *icon in sortedArray) {
        if (count % 16 == 0)
        {
            page = [[SbContainer alloc] init];
            [result addObject:page];
            [page release];
        }
        NSLog(@"%@",icon.displayName);
        [page.items addObject:icon];
        count++;
    }
    
    return result;
}

@end
