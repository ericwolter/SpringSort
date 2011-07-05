//
//  SbFolder.m
//  SpringSort
//
//  Created by Eric Wolter on 06.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SbFolder.h"
#import "Utilities.h"

@implementation SbFolder

@synthesize displayName;

+(id)newFromPlist:(plist_t)thePlist
{
	SbFolder *newFolder = [[SbFolder alloc] init];
	
	if(newFolder) {
		char *val = NULL;
        plist_get_string_val(plist_dict_get_item(thePlist, "displayName"), &val);
		newFolder.displayName = [NSString stringWithUTF8String:val];
		free(val);
        
        plist_t folderContent = plist_dict_get_item(thePlist, "iconLists");
        
        int count = plist_array_get_size(folderContent);
        for (int i = 0; i < count; i++)
        {
			[newFolder.items addObject:[Utilities switchSbType:plist_array_get_item(folderContent, i)]];
        }
	}
	
	return newFolder;
}

-(void)dealloc
{
    self.displayName = nil;
    [super dealloc];
}

-(NSUInteger)count
{
	if (items) {
		return [items count];
	} else {
		return 0;
	}		
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

-(id)copy
{
	SbFolder *newFolder = [[SbFolder alloc] init];
	NSMutableArray *newItems = [[NSMutableArray alloc] initWithArray:self.items copyItems:YES];
	newFolder.items = newItems;
	[newItems release];
	newFolder.displayName = [self.displayName copy];
	return newFolder;
}

@end
