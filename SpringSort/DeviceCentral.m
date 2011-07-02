//
//  DeviceCentral.m
//  SpringSort
//
//  Created by Eric Wolter on 29.06.11.
//  Copyright 2011 private. All rights reserved.
//

#import "DeviceCentral.h"

void raw_device_event(const idevice_event_t *event, void *delegate)
{
	DeviceCentral *central = (DeviceCentral *)delegate;
	[central deviceConnectedEvent:event];
}

@implementation DeviceCentral

@synthesize delegate;
@synthesize devicesCache;

- (id)init
{
    self = [super init];
    if (self) {
		idevice_event_subscribe(raw_device_event, self);
    }
    
    return self;
}

- (void)dealloc
{
	idevice_event_unsubscribe();
    [super dealloc];
}

- (NSArray *)getConnectedUuids {
	char **devices = NULL;
	int    count;
	
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

-(void)deviceConnectedEvent:(const idevice_event_t *)event
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *uuid = [[NSString alloc] initWithUTF8String:event->uuid];
	if (event->event == IDEVICE_DEVICE_ADD) {
		Device *d = [[Device alloc] initWithUuid:uuid];
		[self.devicesCache setObject:d forKey:uuid];
		[self.delegate deviceAdded:d];
    } else if (event->event == IDEVICE_DEVICE_REMOVE) {
		[self.delegate deviceRemoved:[self.devicesCache objectForKey:uuid]];
		[self.devicesCache removeObjectForKey:uuid];
    }
	[uuid release];
	[pool drain];
}

@end
