//
//  HouseArrestService.h
//  SpringSort
//
//  Created by Eric Wolter on 04.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libimobiledevice/house_arrest.h>
#import <plist/plist.h>

@class Device;

@interface HouseArrestService : NSObject {
@private
	Device *device;
	int port;	
}

-(id)initOnDevice:(Device *)theDevice atPort:(int)thePort;
-(plist_t)getMetadata:(const char *)bundleIdentifier;

@end
