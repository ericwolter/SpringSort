//
//  UsbUtility.m
//  SpringSort
//
//  Created by Eric Wolter on 04.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "UsbUtility.h"
#import <libimobiledevice/libimobiledevice.h>

@implementation UsbUtility

+ (NSString *) firstDeviceUuid
{
    return [[UsbUtility deviceList] objectAtIndex:0];
}

+ (NSArray *) deviceList
{
    char **devices = NULL;
    int count;
    if (idevice_get_device_list(&devices, &count) < 0) {
        NSLog(@"ERROR: Unable to retrieve device list!");
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        [array addObject:[NSString stringWithCString:devices[0] encoding:NSUTF8StringEncoding]];
    }
    
    return array;
}

@end
