//
//  SortAlgorithms.m
//  SpringSort
//
//  Created by Eric Wolter on 02.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SortAlgorithms.h"
#import "SbIcon.h"
#import "SbFolder.h"

@implementation SortAlgorithms

+(void)flatten:(SbContainer *)container IntoArray:(NSMutableArray *)flat
{
    for (id item in container.items) {
        if ([item isKindOfClass:[SbContainer class]]) {
            [self flatten:item IntoArray:flat];
        }
        else if ([item isKindOfClass:[SbFolder class]]) {
            [self flatten:item IntoArray:flat];
        }
        else {
            [flat addObject:item];
        }
    }
}

+(void)alphabetically:(SbState *)state
{
    NSMutableArray *flatten = [NSMutableArray array];
    
    for (int i = 2; i < [state.mainContainer.items count]; i++) {
        [SortAlgorithms flatten:[state.mainContainer.items objectAtIndex:i] IntoArray:flatten];
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"displayName"
                                                  ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [flatten sortedArrayUsingDescriptors:sortDescriptors];
    
    SbContainer *newContainer = [[SbContainer alloc] init];
    [newContainer.items addObject:[state.mainContainer.items objectAtIndex:0]];
    [newContainer.items addObject:[state.mainContainer.items objectAtIndex:1]];
    
    int count = 0;
    SbContainer *page;
    for (SbIcon *icon in sortedArray) {
        if (count % 16 == 0)
        {
            page = [[SbContainer alloc] init];
            [newContainer.items addObject:page];
            [page release];
        }
        NSLog(@"%@",icon.displayName);
        [page.items addObject:icon];
        count++;
    }
    
    state.mainContainer = newContainer;
}

+(void)byGenreInFolders:(SbState *)state
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GenreID-en" ofType:@"plist"];
    NSDictionary *genres = [[NSDictionary alloc] initWithContentsOfFile:path];
    [path release];
    
    NSMutableArray *flatten = [NSMutableArray array];
    for (int i = 2; i < [state.mainContainer.items count]; i++) {
        [SortAlgorithms flatten:[state.mainContainer.items objectAtIndex:i] IntoArray:flatten];
    }    
    
    NSMutableDictionary *byGenre = [NSMutableDictionary dictionary];
    for (SbIcon *icon in flatten) {
        if ([icon.genreIds count] > 0) {
            NSString *primaryGenre = [genres objectForKey:[[icon.genreIds objectAtIndex:0] stringValue]];
            if(![byGenre objectForKey:primaryGenre]) {
                [byGenre setObject:[NSMutableArray array] forKey:primaryGenre];
            }
            [[byGenre objectForKey:primaryGenre] addObject:icon];
        }
        else
        {
            if(![byGenre objectForKey:@"Uncategorized"]) {
                [byGenre setObject:[NSMutableArray array] forKey:@"Uncategorized"];
            }
            [[byGenre objectForKey:@"Uncategorized"] addObject:icon];
        }
    }
    
    SbContainer *newContainer = [[SbContainer alloc] init];
    [newContainer.items addObject:[state.mainContainer.items objectAtIndex:0]];
    [newContainer.items addObject:[state.mainContainer.items objectAtIndex:1]];
    
    NSArray* genreKeys = [NSArray arrayWithArray:[byGenre allKeys]]; 
    NSSortDescriptor *desc = [[[NSSortDescriptor alloc]
                               initWithKey:nil ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease]; 
    NSArray *sortedGenres = [genreKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:desc]];

    int count = 0;
    SbContainer *page;
    for(NSString *genre in sortedGenres)
    {
        if (count % 16 == 0)
        {
            page = [[SbContainer alloc] init];
            [newContainer.items addObject:page];
            [page release];
        }
        SbContainer *folderContent;
        int folderCount = 0;
        for (SbIcon *icon in [byGenre objectForKey:genre])
        {
            if (folderCount % 12 == 0)
            {
                SbFolder *folder = [[SbFolder alloc] init];
                folder.displayName = genre;
                folderContent = [[SbContainer alloc] init];
                [folder.items addObject:folderContent];
                [folderContent release];
                [page.items addObject:folder];
                [folder release];
            }
            [folderContent.items addObject:icon];
            folderCount++;
        }
        count++;        
    }
    
    state.mainContainer = newContainer;
    
    [sortedGenres release];
    [genres release];
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
