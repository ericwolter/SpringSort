//
//  SbAppIcon.m
//  SpringSort
//
//  Created by Eric Wolter on 14.06.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SbAppIcon.h"

@interface SbIcon()
-(NSString *)extractBundleIdentifier;
@end

@implementation SbAppIcon

@synthesize bundleIdentifier;

-(NSString *)bundleIdentifier
{
	if(!bundleIdentifier) {
		bundleIdentifier = [[self extractBundleIdentifier] retain];
	}
	
	return bundleIdentifier;
}

-(NSString *)extractBundleIdentifier
{
	char *val = NULL;
	plist_t item = plist_dict_get_item(self.node, "bundleIdentifier");
	if (item) {
		plist_get_string_val(item, &val);
		NSString *value = [NSString stringWithUTF8String:val];
		free(val);
        return value;    
	}
	return nil;
}

-(void)dealloc
{
	[bundleIdentifier release];
	[super dealloc];
}

@end
