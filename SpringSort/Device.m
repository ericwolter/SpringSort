//
//  Device.m
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import "Device.h"

@implementation Device

@synthesize uuid, idevice, springBoardService, houseArrestService;

- (id) initWithUuid: (NSString *)theUuid
{
    self = [super init];
    if (self)
    {
        self.uuid = theUuid;
        
        [self start];
    }
    return self;
}

-(void)start
{
    if (idevice_new(&idevice, [self.uuid cStringUsingEncoding:NSUTF8StringEncoding]) == IDEVICE_E_SUCCESS) {
		// Starting services
		uint16_t port = 0;
		port = [self startSpringBoard];
		if (port) {
			self.springBoardService = [[SpringBoardService alloc] initOnDevice:self atPort:port];
		}
		port = [self startHouseArrest];
		if (port) {
			self.houseArrestService = [[HouseArrestService alloc] initOnDevice:self atPort:port];
		}
	} else {
		NSLog(@"No device found, is it plugged in?");
	}
}

-(uint16_t)startSpringBoard
{
	uint16_t port = 0;
	
	lockdownd_client_t clientLockdown;
	if (lockdownd_client_new_with_handshake(self.idevice, &clientLockdown, "springsort") == LOCKDOWN_E_SUCCESS) {
		if ((lockdownd_start_service(clientLockdown, "com.apple.springboardservices", &port) != LOCKDOWN_E_SUCCESS) || !port) {
			NSLog(@"Could not start springboard service!");
		}
	} else {
		NSLog(@"Could not connect to lockdownd!");
	}
	
	if(clientLockdown) {
		lockdownd_client_free(clientLockdown);
	}
	
	return port;
}
-(uint16_t)startHouseArrest
{
	uint16_t port = 0;
	
	lockdownd_client_t clientLockdown;
	if (lockdownd_client_new_with_handshake(self.idevice, &clientLockdown, "springsort") == LOCKDOWN_E_SUCCESS) {
		if ((lockdownd_start_service(clientLockdown, "com.apple.mobile.house_arrest", &port) != LOCKDOWN_E_SUCCESS) || !port) {
			NSLog(@"Could not connect to housearrest service!");
		}
	} else {
		NSLog(@"Could not connect to lockdownd!");
	}
	
	if(clientLockdown) {
		lockdownd_client_free(clientLockdown);
	}
	
	return port;
}


- (void) dealloc
{
    if(self.idevice) {
        idevice_free(self.idevice);
		idevice = nil;
    }
    self.springBoardService = nil;
    self.houseArrestService = nil;
    [super dealloc];
}

@end
