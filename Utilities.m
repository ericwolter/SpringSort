//
//  Utilities.m
//  SpringSort
//
//  Created by Eric Wolter on 12.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

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

+(plist_t)switchSbType:(plist_t)plist
{
    if (plist_get_node_type(plist) == PLIST_ARRAY) {
        return [[SbContainer alloc] initFromPlist:plist];
    }
    else {
        if(plist_dict_get_item(plist, "iconLists")) {
            return [[SbFolder alloc] initFromPlist:plist];
        }
        else
        {
            return [[SbIcon alloc] initFromPlist:plist];
        }
    }
	
}

@end
