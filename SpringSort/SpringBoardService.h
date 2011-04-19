//
//  SpringBoardService.h
//  SpringSort
//
//  Created by Eric Wolter on 04.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libimobiledevice/sbservices.h>

@class Device;

@interface SpringBoardService : NSObject {
@private
	Device *device;
	int port;	
}

-(id)initOnDevice:(Device *)theDevice atPort:(int)thePort;
-(plist_t)getState;
-(void)setState:(plist_t)plist;
-(NSImage* )getWallpaper;
-(NSImage*)getIcon:(const char *)bundleIdentifier;

@end
