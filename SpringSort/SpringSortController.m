//
//  SpringSortController.m
//  SpringSort
//
//  Created by Eric Wolter on 19.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SpringSortController.h"
#import "Device.h"
#import "SbState.h"
#import "SbIcon.h"

@implementation SpringSortController

@synthesize device, state;

- (id)initWithDevice:(Device *)theDevice;
{
    self = [super init];
    if (self) {
		self.device = theDevice;
		plist_t p = [self.device.springBoardService getState];
		self.state = [[SbState alloc] initFromPlist:p];
		
		cacheIcons = [[NSMutableDictionary alloc] init];
		cacheGenres = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
	[cacheIcons release];
	[cacheGenres release];
	[wallpaper release];
    [super dealloc];
}

-(NSImage *)getWallpaper
{
	if (!wallpaper) {
		wallpaper = [self.device.springBoardService getWallpaper];
		[wallpaper retain];
	}
	
	return wallpaper;
}

-(NSImage *)getImageForIcon:(SbIcon *)icon
{
	NSImage *image = [cacheIcons objectForKey:icon.displayIdentifier];
	
	if(!image) {
		image = [self.device.springBoardService getIcon:[icon.displayIdentifier cStringUsingEncoding:NSUTF8StringEncoding]];
		[cacheIcons setObject:image forKey:icon.displayIdentifier]; 
	}
	
	return image;
}

-(NSArray *)getGenresforIcon:(SbIcon *)icon
{
	NSArray *genres = [cacheGenres objectForKey:icon.bundleIdentifier];
	
	if(!genres) {
		genres = [self.device.houseArrestService getGenres:[icon.bundleIdentifier cStringUsingEncoding:NSUTF8StringEncoding]];
		if ([genres count] > 0) {
			[cacheGenres setObject:genres forKey:icon.bundleIdentifier];
		}
	}
	
	return genres;
}

@end
