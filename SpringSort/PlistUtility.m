//
// PListUtility.m
// SpringSort
//
// Created by Eric Wolter on 02.04.11.
// Copyright 2011 private. All rights reserved.
//

#import "PlistUtility.h"

@implementation PlistUtility

+ (NSString *)toString:(plist_t)plist {
	char    *xml    = NULL;
	uint32_t length = 0;

	plist_to_xml(plist, &xml, &length);

	NSString *string = [NSString stringWithUTF8String:xml];
	free(xml);

	return string;
}

@end
