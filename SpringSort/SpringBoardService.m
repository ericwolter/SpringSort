//
//  SpringBoardService.m
//  SpringSort
//
//  Created by Eric Wolter on 04.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SpringBoardService.h"
#import "Device.h"

@interface SpringBoardService()
-(void)getNewPort;
-(sbservices_client_t)connect;
-(void)disconnect:(sbservices_client_t)client;
@end

@implementation SpringBoardService

-(id)initOnDevice:(Device *)theDevice atPort:(int)thePort;
{
    self = [super init];
    if (self)
    {
		device = theDevice;
		port = thePort;
    }
    return self;
}

-(plist_t)getState
{
	plist_t state = NULL;
	
	sbservices_client_t client = [self connect];
	if (client) {
		if (sbservices_get_icon_state(client, &state, "2") != SBSERVICES_E_SUCCESS || !state) {
			NSLog(@"Could not get icon state!");
		}
	}
	[self disconnect:client];
	
	return state;
}


-(void)setState:(plist_t)plist
{
	sbservices_client_t client = [self connect];
	if (client) {
		if (sbservices_set_icon_state(client, plist) != SBSERVICES_E_SUCCESS) {
			NSLog(@"Could not set new icon state!");
		}
	}
	[self disconnect:client];
}

-(NSImage* )getWallpaper
{
	NSImage *image = nil;
	
	sbservices_client_t client = [self connect];
	if (client) {
		char *pngData = NULL;
		uint64_t pngSize = 0;
		
		if(sbservices_get_home_screen_wallpaper_pngdata(client, &pngData, &pngSize) != SBSERVICES_E_SUCCESS || pngSize <= 0) {
			NSLog(@"Could not get home screen wallpaper");
		} else {
			image = [[NSImage alloc] initWithData:[NSData dataWithBytes:pngData length:pngSize]];
			free(pngData);
		}
	}
	[self disconnect:client];
	
	return [image autorelease];
}

-(NSImage*)getIcon:(const char *)displayIdentifier
{
	NSImage *image = nil;
	
	sbservices_client_t client = [self connect];
	if(client) {
		char *pngData = NULL;
		uint64_t pngSize = 0;
		
		if(sbservices_get_icon_pngdata(client, displayIdentifier, &pngData, &pngSize) != SBSERVICES_E_SUCCESS || pngSize <= 0) {
			NSLog(@"Could not get icon for %s", displayIdentifier);
		} else {
			image = [[NSImage alloc] initWithData:[NSData dataWithBytes:pngData length:pngSize]];
			free(pngData);
		}
	}
	[self disconnect:client];	   
	
	return [image autorelease];
}

-(void)getNewPort
{
	port = [device startSpringBoard];
}

-(sbservices_client_t)connect
{
	[self getNewPort];
	
	sbservices_client_t client = NULL;
    if (sbservices_client_new(device.idevice, port, &client) != SBSERVICES_E_SUCCESS)
        NSLog(@"Could not connect to springboard service!");
	
	return client;
}

-(void)disconnect:(sbservices_client_t)client
{
	if(client)
		sbservices_client_free(client);
}

@end
