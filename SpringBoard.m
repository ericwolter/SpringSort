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
        plist_t page = plist_array_get_item(plist, pageIndex);
        
        SbContainer *container = [[SbContainer alloc] init];
        [self.pages addObject:container];
        
        int pageSize = plist_array_get_size(page);
        int itemIndex;
        for (itemIndex = 0; itemIndex < pageSize; itemIndex++)
        {
            plist_t item = plist_array_get_item(page, itemIndex);
            plist_t folder = plist_dict_get_item(item, "iconLists");
            
            if (!folder)
            {
                [container.items addObject:[self createIcon: item]];
            }
            else
            {
                SbContainer *folder = [[SbContainer alloc] init];
                [self.pages addObject:folder];
                
                int folderSize = plist_array_get_size(folder);
                int folderItemIndex;
                for (folderItemIndex = 0; folderItemIndex < folderSize; folderItemIndex++)
                {
                    plist_t folderItem = plist_array_get_item(folder, folderItemIndex);
                    
                    [folder.items addObject:[self createIcon:folderItem]];
                }
                
                [folder release];
            }
        }
        
        [container release];
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
                plist_dict_insert_item(plist_folder, "displayName", plist_new_string([item.displayName cStringUsingEncoding:NSUTF8StringEncoding]));
                
                plist_t plist_folderContainer = plist_new_array();
                plist_t plist_folderItems = plist_new_array();
                
                for(SbIcon *icon in folder.items)
                {
                    plist_array_append_item(plist_folderItems, plist_copy(icon.node));
                }
                
                plist_array_append_item(plist_folderContainer, plist_folderItems);
                plist_dict_insert_item(plist_folder, "iconLists", plist_folderContainer);
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
