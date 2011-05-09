//
//  SbIcon.m
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SbIcon.h"

@implementation SbIcon

@synthesize node;

-(id)initFromPlist:(plist_t)plist
{
    self = [super init];
    if (self)
    {
        self.node = plist_copy(plist);
    }
    return self;
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
    plist_t item = plist_dict_get_item(self.node, "displayName");
    if (item) {
        plist_get_string_val(item, &val);
        return [NSString stringWithUTF8String:val];    
    }
    return nil;
}

-(NSString *)bundleIdentifier
{
    char *val = NULL;
    plist_t item = plist_dict_get_item(self.node, "bundleIdentifier");
    if (item) {
        plist_get_string_val(item, &val);
        return [NSString stringWithUTF8String:val];    
    }
    return nil;
    
}

-(NSString *)displayIdentifier
{
    char *val = NULL;
    plist_t item = plist_dict_get_item(self.node, "displayIdentifier");
    if (item) {
        plist_get_string_val(item, &val);
        return [NSString stringWithUTF8String:val];    
    }
    return nil;
    
}

@end
