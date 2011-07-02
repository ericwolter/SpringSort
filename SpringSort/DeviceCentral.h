//
//  DeviceCentral.h
//  SpringSort
//
//  Created by Eric Wolter on 29.06.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libimobiledevice/libimobiledevice.h>
#import "Device.h"
#import "DeviceDelegate.h"

@interface DeviceCentral : NSObject {
@private
	id<DeviceDelegate> delegate;
	NSMutableDictionary *devicesCache;
}

@property (nonatomic, assign) id<DeviceDelegate> delegate;
@property (nonatomic, retain) NSMutableDictionary *devicesCache;

- (NSArray *)getConnectedUuids;
-(void)deviceConnectedEvent:(const idevice_event_t *)event;

@end
