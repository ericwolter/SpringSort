//
//  Device.h
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libimobiledevice/sbservices.h>
#import <libimobiledevice/lockdown.h>

@interface Device : NSObject {
    sbservices_client_t client;
}

- (id) initWithUuid: (const char *)uuid;
- (id) init;
- (void) dealloc;

- (plist_t) device_sbs_get_iconstate;
- (BOOL)device_sbs_set_iconstate:(plist_t)plist;

+ (const char*) getFirstDevice;

@end
