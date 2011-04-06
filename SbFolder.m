//
//  SbFolder.m
//  SpringSort
//
//  Created by Eric Wolter on 06.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SbFolder.h"
#import "SbState.h"

@implementation SbFolder

@synthesize displayName, items;

+(SbFolder *)initFromPlist:(plist_t)plist
{
    SbFolder *folder = [[SbFolder alloc] init];
    folder.items = [NSMutableArray array];
    
    char *val = NULL;
    plist_get_string_val(plist_dict_get_item(plist, "displayName"), &val);
    folder.displayName = [NSString stringWithUTF8String:val];
    
    plist_t folderContent = plist_dict_get_item(plist, "iconLists");
    
    int count = plist_array_get_size(folderContent);
    for (int i = 0; i < count; i++)
    {
        [folder.items addObject:[SbState switchSbType:plist_array_get_item(folderContent, i)]];
    }
    
    return folder; 
}

-(void)dealloc
{
    self.displayName = nil;
    self.items = nil;
    [super dealloc];
}

-(plist_t)toPlist
{
    plist_t pFolder = plist_new_dict();
    plist_dict_insert_item(pFolder, "displayName", plist_new_string([self.displayName cStringUsingEncoding:NSUTF8StringEncoding]));
    plist_t pFolderContent = plist_new_array();
    plist_dict_insert_item(pFolder, "iconLists", pFolderContent);
    
    for (id item in self.items)
    {
        plist_array_append_item(pFolderContent, [item toPlist]);
    }
    
    return pFolder;
}

@end
