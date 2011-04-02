//
//  PListUtility.m
//  SpringSort
//
//  Created by Eric Wolter on 02.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "PListUtility.h"


@implementation PListUtility

+(NSString *)toXml:(plist_t)plist
{
    char *xml = NULL;
    uint32_t length = 0;
    plist_to_xml(plist, &xml, &length);
    
    return [NSString stringWithUTF8String:xml];
}


@end
