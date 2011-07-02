//
// Utilities.m
// SpringSort
//
// Created by Eric Wolter on 12.04.11.
// Copyright 2011 private. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (void)flatten:(SbContainer *)container IntoArray:(NSMutableArray *)flat {
	for (id item in container.items) {
		if ([item isKindOfClass:[SbIcon class]]) {
			[flat addObject:item];
		} else if ([item isKindOfClass:[SbFolder class]]) {
			[self flatten:item IntoArray:flat];
		} else {
			[self flatten:item IntoArray:flat];
		}
	}
}

+ (plist_t)switchSbType:(plist_t)plist {
	if (plist_get_node_type(plist) == PLIST_ARRAY) {
		if (plist_array_get_size(plist) > 0) {
			if(plist_get_node_type(plist_array_get_item(plist, 0)) != PLIST_ARRAY) {
				return [SbPage newFromPlist:plist];
			}
		}
		return [SbContainer newFromPlist:plist];
	} else {
		if (plist_dict_get_item(plist, "iconLists")) {
			return [SbFolder newFromPlist:plist];
		} else {
			return [SbIcon newFromPlist:plist];
		}
	}
}

@end
