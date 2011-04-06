//
//  Device.m
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import "Device.h"

@implementation Device

@synthesize uuid, springBoardService, houseArrestService;

- (id) initWithUuid: (NSString *)theUuid
{
    self = [super init];
    if (self)
    {
        self.uuid = theUuid;
        
        [self restart];
    }
    return self;
}

- (void) dealloc
{
    [self clean];
    self.springBoardService = nil;
    self.houseArrestService = nil;
    [super dealloc];
}

-(BOOL)restart
{
    [self deviceStart];
    if (!_device) {
        [self clean];
        return NO;
    }
    
    [self lockdownStart];
    if (!_lockdownd) {
        [self clean];
        return NO;
    }
    
    [self springBoardStart];
    if (!_springBoardClient) {
        [self clean];
        return NO;
    }
    
    self.springBoardService = [[SpringBoardService alloc] initWithSpringBoardClient:_springBoardClient];
    if (!self.springBoardService) {
        return NO;
    }
    
    [self houseArrestStart];
    if (!_houseArrestClient) {
        [self clean];
        return NO;
    }
    
    self.houseArrestService = [[HouseArrestService alloc] initWithHouseArrestClient:_houseArrestClient];
    if (!self.houseArrestService) {
        [self clean];
        return NO;
    }
    
    return YES;
}


-(void)clean
{
    if(_device) {
        idevice_free(_device);
    }
    if(_lockdownd) {
        lockdownd_client_free(_lockdownd);
    }
    if(_springBoardClient) {
        sbservices_client_free(_springBoardClient);
    }
    if(_houseArrestClient) {
        house_arrest_client_free(_houseArrestClient);
    }    
}

-(void)deviceStart
{
    if (IDEVICE_E_SUCCESS != idevice_new(&_device, [self.uuid cStringUsingEncoding:NSUTF8StringEncoding])) {
        NSLog(@"No device found, is it plugged in?");
    }    
}

-(void)lockdownStart
{
    if (LOCKDOWN_E_SUCCESS != lockdownd_client_new_with_handshake(_device, &_lockdownd, "springsort")) {
        NSLog(@"Could not connect to lockdownd!");
    }    
}

-(void)springBoardStart
{    
    uint16_t port = 0;
    if ((lockdownd_start_service(_lockdownd, "com.apple.springboardservices", &port) != LOCKDOWN_E_SUCCESS) || !port) {
        NSLog(@"Could not start com.apple.springboardservices service! Remind that this feature is only supported in OS 3.1 and later!");
    }
    
    if (sbservices_client_new(_device, port, &_springBoardClient) != SBSERVICES_E_SUCCESS) {
        NSLog(@"Could not connect to springboard service!");
    }
}

-(void)houseArrestStart
{
    uint16_t port = 0;
    if ((lockdownd_start_service(_lockdownd, "com.apple.mobile.house_arrest", &port) != LOCKDOWN_E_SUCCESS) || !port)
    {
        NSLog(@"Could not start com.apple.mobile.house_arrest!");
    }
    
    if (house_arrest_client_new(_device, port, &_houseArrestClient) != HOUSE_ARREST_E_SUCCESS)
    {
        NSLog(@"Could not connect to housearrest service!");
    }
}

//- (BOOL)device_sbs_set_iconstate:(plist_t)plist
//{
//    if (sbservices_set_icon_state(client, plist) != SBSERVICES_E_SUCCESS)
//    {
//        NSLog(@"Could not set new icon state!");
//        return NO;
//    }
//    
//    return YES;
//}
@end
