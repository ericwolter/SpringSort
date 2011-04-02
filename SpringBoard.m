//
//  SpringBoard.m
//  SpringSort
//
//  Created by Eric Wolter on 23.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SpringBoard.h"
#import "SbContainer.h"
#import "SbIcon.h"

@interface SpringBoard()
- (SbIcon *) createIcon: (plist_t) item;
@end

@implementation SpringBoard

@synthesize pages;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.pages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self.pages release];
    [super dealloc];
}

- (SbIcon *) createIcon: (plist_t) item
{
    SbIcon *icon = [[SbIcon alloc] init];
    char *val = NULL;
    plist_get_string_val(plist_dict_get_item(item, "displayName"), &val);
    icon.displayName = [NSString stringWithUTF8String:val];
    plist_get_string_val(plist_dict_get_item(item, "displayIdentifier"), &val);
    icon.displayIdentifier = [NSString stringWithUTF8String:val];
    
    plist_t bundleIdentifierKey = plist_dict_get_item(item, "bundleIdentifier");
    if (bundleIdentifierKey)
    {
        plist_get_string_val(bundleIdentifierKey, &val);
        icon.bundleIdentifier = [NSString stringWithUTF8String:val];
    }
    
    icon.node = plist_copy(item);
    
    return [icon autorelease];
}

- (void)fillWith:(plist_t) plist
{
    int pagesCount = plist_array_get_size(plist);
    int pageIndex;
    for (pageIndex = 0; pageIndex < pagesCount; pageIndex++)
    {
        plist_t plist_page = plist_array_get_item(plist, pageIndex);
        
        SbContainer *page = [[SbContainer alloc] init];
        [self.pages addObject:page];
        
        int pageSize = plist_array_get_size(plist_page);
        int itemIndex;
        for (itemIndex = 0; itemIndex < pageSize; itemIndex++)
        {
            plist_t plist_item = plist_array_get_item(plist_page, itemIndex);
            plist_t plist_folder = plist_dict_get_item(plist_item, "iconLists");
            
            if (!plist_folder)
            {
                [page.items addObject:[self createIcon: plist_item]];
            }
            else
            {
                SbContainer *folder = [[SbContainer alloc] init];
                
                char *val = NULL;
                plist_get_string_val(plist_dict_get_item(plist_item, "displayName"), &val);
                folder.displayName = [NSString stringWithUTF8String:val];
                
                plist_t plist_folder_items = plist_array_get_item(plist_folder, 0);
                int folderSize = plist_array_get_size(plist_folder_items);
                int folderItemIndex;
                for (folderItemIndex = 0; folderItemIndex < folderSize; folderItemIndex++)
                {
                    plist_t plist_folder_item = plist_array_get_item(plist_folder_items, folderItemIndex);
                    [folder.items addObject:[self createIcon:plist_folder_item]];
                }
                
                [page.items addObject:folder];
                [folder release];
            }
        }
        
        [page release];
    }
}

- (plist_t)export
{
    plist_t plist = plist_new_array();
    
    for(SbContainer *page in self.pages)
    {
        plist_t plist_page = plist_new_array();
        
        for (SbItem *item in page.items)
        {
            if([item isKindOfClass:[SbContainer class]])
            {   
                SbContainer *folder = (SbContainer *)item;
                plist_t plist_folder = plist_new_dict();
                plist_dict_insert_item(plist_folder, "displayName", plist_new_string([folder.displayName cStringUsingEncoding:NSUTF8StringEncoding]));
                
                plist_t plist_folderContainer = plist_new_array();
                plist_t plist_folderItems = plist_new_array();
                
                for(SbIcon *icon in folder.items)
                {
                    plist_array_append_item(plist_folderItems, plist_copy(icon.node));
                }
                
                plist_array_append_item(plist_folderContainer, plist_folderItems);
                plist_dict_insert_item(plist_folder, "iconLists", plist_folderContainer);
                plist_array_append_item(plist_page, plist_folder);
            }
            else if([item isKindOfClass:[SbIcon class]])
            {
                SbIcon *icon = (SbIcon *)item;
                plist_array_append_item(plist_page, plist_copy(icon.node));
            }
        }
        
        plist_array_append_item(plist, plist_page);
    }
        
    return plist;
}


@end
