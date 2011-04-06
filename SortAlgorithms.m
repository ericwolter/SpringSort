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
//    NSMutableArray *flatten = [NSMutableArray array];
//    
//    int pageSize = [pages count];
//    for (int pageIndex = 2; pageIndex < pageSize; pageIndex++)
//    {
//        SbContainer *page = [pages objectAtIndex:pageIndex];
//        for (SbItem* item in page.items)
//        {
//            if([item isKindOfClass:[SbContainer class]])
//            {   
//                SbContainer *folder = (SbContainer *)item;
//                for(SbIcon *icon in folder.items)
//                {
//                    [flatten addObject:icon];
//                }
//            }    
//            else if([item isKindOfClass:[SbIcon class]])
//            {
//                [flatten addObject:item];
//            }   
//        }
//    }
//    
//    NSSortDescriptor *sortDescriptor;
//    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"displayName"
//                                                  ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//    NSArray *sortedArray;
//    sortedArray = [flatten sortedArrayUsingDescriptors:sortDescriptors];
//    
//    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[flatten count]+2];
//    [result addObject:[pages objectAtIndex:0]];
//    [result addObject:[pages objectAtIndex:1]];
//    
//    int count = 0;
//    SbContainer *page;
//    for (SbIcon *icon in sortedArray) {
//        if (count % 16 == 0)
//        {
//            page = [[SbContainer alloc] init];
//            [result addObject:page];
//            [page release];
//        }
//        NSLog(@"%@",icon.displayName);
//        [page.items addObject:icon];
//        count++;
//    }
//    
//    return result;
    return nil;
}

+(NSMutableArray *)alphabeticallyInFolders:(NSMutableArray *)pages
{
//    NSMutableArray *flatten = [NSMutableArray array];
//    
//    int pageSize = [pages count];
//    for (int pageIndex = 2; pageIndex < pageSize; pageIndex++)
//    {
//        SbContainer *page = [pages objectAtIndex:pageIndex];
//        for (SbItem* item in page.items)
//        {
//            if([item isKindOfClass:[SbContainer class]])
//            {   
//                SbContainer *folder = (SbContainer *)item;
//                for(SbIcon *icon in folder.items)
//                {
//                    [flatten addObject:icon];
//                }
//            }    
//            else if([item isKindOfClass:[SbIcon class]])
//            {
//                [flatten addObject:item];
//            }   
//        }
//    }
//    
//    NSSortDescriptor *sortDescriptor;
//    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"displayName"
//                                                  ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//    NSArray *sortedArray;
//    sortedArray = [flatten sortedArrayUsingDescriptors:sortDescriptors];
//    
//    NSMutableDictionary *sortedDict = [NSMutableDictionary dictionary];
//    for (SbIcon *icon in sortedArray)
//    {
//        NSString *first = [[icon.displayName uppercaseString] substringToIndex:1];
//        NSMutableArray *array = [sortedDict objectForKey:first];
//        if(array)
//        {
//            [array addObject:icon];
//        }
//        else
//        {
//            array = [[NSMutableArray alloc] init];
//            [array addObject:icon];
//            [sortedDict setObject:array forKey:first];
//            [array release];
//        }
//    }
//    
//    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[sortedDict count]+2];
//    [result addObject:[pages objectAtIndex:0]];
//    [result addObject:[pages objectAtIndex:1]];
//    
//    int count = 0;
//    SbContainer *page;
//    NSArray *keys = [sortedDict allKeys];
//    
//	for (NSString *key in keys)
//    {
//        NSLog(@"%@", key);
//        if (count % 16 == 0)
//        {
//            page = [[SbContainer alloc] init];
//            [result addObject:page];
//            [page release];
//        }
//        
//        NSMutableArray *array = [sortedDict objectForKey:key];
//        SbContainer *folder;
//        int folderCount = 0;
//        for (SbIcon *icon in array)
//        {
//            if (folderCount % 12 == 0)
//            {
//                folder = [[SbContainer alloc] init];
//                folder.displayName = key;
//                [page.items addObject:folder];
//                [folder release];
//            }
////            NSLog(@"%@",icon.displayName);
//            [folder.items addObject:icon];
//            folderCount++;
//        }
//        count++;
//    }
//    
//    return result;
    return nil;
}

@end
