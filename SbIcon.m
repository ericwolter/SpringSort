//
//  SbIcon.m
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SbIcon.h"

@implementation SbIcon

@synthesize node, genreIds;

+(SbIcon *)initFromPlist:(plist_t)plist
{
    SbIcon *icon = [[SbIcon alloc] init];
    icon.node = plist_copy(plist);
    return icon;
}

-(void)dealloc
{
    if(self.node) {
        plist_free(node);
    }
    [super dealloc];
}

-(plist_t)toPlist;
{
    return plist_copy(self.node);
}

-(NSString *)displayName
{
    char *val = NULL;
    plist_get_string_val(plist_dict_get_item(self.node, "displayName"), &val);
    return [NSString stringWithUTF8String:val];
}

-(NSString *)bundleIdentifier
{
    char *val = NULL;
    plist_get_string_val(plist_dict_get_item(self.node, "bundleIdentifier"), &val);
    return [NSString stringWithUTF8String:val];
}

@end
