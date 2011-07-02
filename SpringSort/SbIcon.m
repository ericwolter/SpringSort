//
//  SbIcon.m
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SbIcon.h"
#import "SbAppleIcon.h"
#import "SbWebIcon.h"
#import "SbStoreIcon.h"

@implementation SbIcon

@synthesize node;
@synthesize genres;
@synthesize icon;

+(id)newFromPlist:(plist_t)thePlist
{
	id newIcon;
	if(plist_dict_get_item(thePlist, "webClipURL")) {
		newIcon = [[SbWebIcon alloc] init];
	} else {
		NSString *displayIdentifier = [SbIcon extractDisplayIdentifier:thePlist];
		if([displayIdentifier hasPrefix:@"com.apple."]) {
			newIcon = [[SbAppleIcon alloc] init];
		} else {
			newIcon = [[SbStoreIcon alloc] init];
		}
	}
	
	if(newIcon) {
		[newIcon setNode:plist_copy(thePlist)];
	}
	
	return newIcon;
}

-(void)dealloc
{
    if(self.node) {
        plist_free(node);
    }
	[displayName release];
	[displayIdentifier release];
    [super dealloc];
}

-(plist_t)toPlist;
{
    return plist_copy(self.node);
}

+(NSString *)extractDisplayName:(plist_t)thePlist
{
    char *val = NULL;
    plist_t item = plist_dict_get_item(thePlist, "displayName");
    if (item) {
        plist_get_string_val(item, &val);
		NSString *value = [NSString stringWithUTF8String:val];
		free(val);
        return value;    
    }
    return nil;
}

+(NSString *)extractDisplayIdentifier:(plist_t)thePlist
{
    char *val = NULL;
    plist_t item = plist_dict_get_item(thePlist, "displayIdentifier");
    if (item) {
        plist_get_string_val(item, &val);
		NSString *value = [NSString stringWithUTF8String:val];
		free(val);
        return value;    
    }
    return nil;	
}

-(NSString *)displayName
{
	if (!displayName) {
		displayName = [[SbIcon extractDisplayName:self.node] retain];
	}
	
	return displayName;
}

-(NSString *)displayIdentifier
{
	if(!displayIdentifier) {
		displayIdentifier = [[SbIcon extractDisplayIdentifier:self.node] retain];
	}
	
	return displayIdentifier;
}

@end
