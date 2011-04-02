//
//  Device.m
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import "Device.h"

@interface Device()
- (BOOL) initSpringboardForUuid:(const char *)uuid;
@end

@implementation Device

+ (const char*) getFirstDevice
{
    char **list = NULL;
    int i;
    
    if  (idevice_get_device_list(&list, &i) < 0)
    {
        NSLog(@"ERROR: Unable to retrieve device list!");
        return nil;
    }
    
    return list[0];
}

- (BOOL) initSpringboardForUuid:(const char *)uuid;
{
    BOOL result = YES;
    
    idevice_t iDevice = NULL;
    if (IDEVICE_E_SUCCESS != idevice_new(&iDevice, uuid))
    {
        NSLog(@"No device found, is it plugged in?");
        result = NO;
        goto leave_cleanup;
    }
    
    lockdownd_client_t lockdownClient = NULL;
    if (LOCKDOWN_E_SUCCESS != lockdownd_client_new_with_handshake(iDevice, &lockdownClient, "springsort"))
    {
        NSLog(@"Could not connect to lockdownd!");
        result = NO;
        goto leave_cleanup;
    }
    
    uint16_t port = 0;
    if ((lockdownd_start_service(lockdownClient, "com.apple.springboardservices", &port) != LOCKDOWN_E_SUCCESS) || !port) {
        NSLog(@"Could not start com.apple.springboardservices service! Remind that this feature is only supported in OS 3.1 and later!");
        result = NO;
        goto leave_cleanup;
    }
    if (sbservices_client_new(iDevice, port, &client) != SBSERVICES_E_SUCCESS) {
        NSLog(@"Could not connect to springboardservices!");
        result = NO;
        goto leave_cleanup;
    }
    
leave_cleanup:
    if (client)
        lockdownd_client_free(lockdownClient);
    
    if (iDevice)
        idevice_free(iDevice);   
    
    return result;
}

-(id) init
{
    return [self initWithUuid:nil];
}

- (id) initWithUuid: (const char *)uuid
{
    self = [super init];
    if (self)
    {
        if ([self initSpringboardForUuid:uuid] == NO) {
            self = nil;
        }
    }
    return self;
}

- (void) dealloc
{
    if (client) {
        sbservices_client_free(client);
    }
    [super dealloc];
}

- (plist_t) device_sbs_get_iconstate
{
    plist_t iconstate = NULL;
    
    sbservices_error_t err;
    err = sbservices_get_icon_state(client, &iconstate, "2");
    
    if (err != SBSERVICES_E_SUCCESS || !iconstate)
    {
        NSLog(@"Could not get icon state!");
        return nil;
    }
    if (plist_get_node_type(iconstate) != PLIST_ARRAY)
    {
        NSLog(@"icon state is not an array as expected");
        return nil;
    }
    
    return iconstate;
}

- (BOOL)device_sbs_set_iconstate:(plist_t)plist
{
    if (sbservices_set_icon_state(client, plist) != SBSERVICES_E_SUCCESS)
    {
        NSLog(@"Could not set new icon state!");
        return NO;
    }
    
    return YES;
}
@end
