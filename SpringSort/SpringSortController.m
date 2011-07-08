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
#import "SbWebIcon.h"
#import "SbPage.h"
#import "SbAppleIcon.h"
#import "SbStoreIcon.h"
#import "Utilities.h"
#import "PlistUtility.h"

static NSString *cachePath;

@interface SpringSortController()
-(NSInteger)getVersionRaw:(plist_t)metadata;
-(NSInteger)getVersion:(NSDictionary *)metadata;
@end

@implementation SpringSortController

@synthesize device, state;

- (id)initWithDevice:(Device *)theDevice;
{
    self = [super init];
    if (self) {
		progressListeners = [[NSMutableArray alloc] init];
		cache = [[CacheUtility alloc] init];
		
		self.device = theDevice;
		plist_t p = [self.device.springBoardService getState];
		self.state = [SbState newFromPlist:p];
		SbPage *dock = [self.state.mainContainer.items objectAtIndex:0];
		dock.state = PageIsExcluded;
    }
    
    return self;
}

-(void)download
{
	NSMutableArray *icons = [[NSMutableArray alloc] init];
	[Utilities flatten:self.state.mainContainer IntoArray:icons];
	
	NSUInteger count = 0;
	NSUInteger total = [icons count];
	for(SbIcon *icon in icons) {
		NSLog(@"Preloading %@",icon.displayName);
		if([icon isKindOfClass:[SbWebIcon class]]) {
			icon.icon = [self getImageForIcon:icon];
			icon.genres = [NSArray arrayWithObject:@"Bookmarks"];
		} else if ([icon isKindOfClass:[SbAppleIcon class]]) {
			icon.icon = [self getImageForIcon:icon];
			icon.genres = [NSArray arrayWithObject:@"Apple"];
		} else if ([icon isKindOfClass:[SbStoreIcon class]]) {
			SbStoreIcon *storeIcon = (SbStoreIcon *)icon;
			
			BOOL reload = NO;
			NSLog(@"   bundleIdentifier: %@",storeIcon.bundleIdentifier);
			plist_t deviceMetadata = [self.device.houseArrestService getMetadata:[storeIcon.bundleIdentifier cStringUsingEncoding:NSUTF8StringEncoding]];
			NSDictionary *cacheMetadata = [cache getMetadataForIcon:storeIcon];
			if(!cacheMetadata) {
				[cache saveMetadata:deviceMetadata ForIcon:storeIcon.bundleIdentifier];
				reload = YES;
			} else {
				NSInteger deviceVersion = [self getVersionRaw:deviceMetadata];
				NSInteger cacheVersion = [self getVersion:cacheMetadata];
				if(deviceVersion > cacheVersion) {
					[cache saveMetadata:deviceMetadata ForIcon:storeIcon.bundleIdentifier];
					reload = YES;
				}
			}
			
			plist_free(deviceMetadata);
			
			// set icon
			if (reload) {
				NSLog(@"   RELOAD icon");
				storeIcon.icon = [self getImageForIcon:storeIcon];
			} else {
				NSLog(@"   CACHE icon");
				storeIcon.icon = [cache getImageForIcon:storeIcon];
			}
			
			// set genre
			storeIcon.genres = [cache getGenresForIcon:storeIcon];
		}
		
		count = count + 1;
		[self reportProgress:count max:total];
		
		NSLog(@"Loaded %@",icon.displayName);
		NSLog(@"--------------------");
	}
	
	[icons release];
}

-(void)reloadState
{
	plist_t p = [self.device.springBoardService getState];
	SbState* newState = [SbState newFromPlist:p];
	NSMutableArray *newIcons = [[NSMutableArray alloc] init];
	NSMutableArray *oldIcons = [[NSMutableArray alloc] init];
	[Utilities flatten:newState.mainContainer IntoArray:newIcons];
	[Utilities flatten:self.state.mainContainer IntoArray:oldIcons];
	
	for (SbIcon *newIcon in newIcons) {
		for (NSUInteger i = 0; [oldIcons count]; ++i) {
			SbIcon *oldIcon = [oldIcons objectAtIndex:i];
			if([newIcon.displayIdentifier isEqualToString:oldIcon.displayIdentifier]) {
				NSArray *newGenres = [[NSArray alloc] initWithArray:oldIcon.genres copyItems:YES];
				newIcon.genres = newGenres;
				[newGenres release];
				newIcon.icon = oldIcon.icon;
				[oldIcons removeObjectAtIndex:i];
				break;
			}
		}
	}
	
	[newIcons release];
	[oldIcons release];
	SbPage *dock = [newState.mainContainer.items objectAtIndex:0];
	dock.state = PageIsExcluded;
	self.state = newState;
}

-(NSInteger)getVersionRaw:(plist_t)metadata
{
	char *val = NULL;
    plist_t item = plist_dict_get_item(metadata, "bundleVersion");
    if (item) {
        plist_get_string_val(item, &val);
        return [[NSString stringWithUTF8String:val] intValue];    
    }
    return -1;
}

-(NSInteger)getVersion:(NSDictionary *)metadata
{
	return [[metadata objectForKey:@"bundleVersion"] intValue];
}

- (void)dealloc
{
	[progressListeners release];
	[cachePath release];
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
	NSImage *image = [self.device.springBoardService getIcon:[icon.displayIdentifier cStringUsingEncoding:NSUTF8StringEncoding]];
	if(image) {
		[cache saveImage:image ForIcon:icon.displayIdentifier];
	}
	
	return image;
}

-(void)writeState
{
	[self.device.springBoardService setState:[self.state toPlist]];
}

-(void)togglePageState:(NSUInteger)pageIndex;
{
	SbPage *selectedPage = [self.state.mainContainer.items objectAtIndex:pageIndex];
	switch (selectedPage.state) {
		case PageIsIncluded:
			selectedPage.state = PageIsExcluded;
			break;
		case PageIsExcluded:
			selectedPage.state = PageIsTargetOnly;
			break;
		case PageIsTargetOnly:
			selectedPage.state = PageIsIncluded;
		default:
			break;
	}
}

-(void)addProgressListener:(id<ProgressListener>)theListener
{
	[progressListeners addObject:theListener];
}

-(void)removeProgressListener:(id<ProgressListener>)theListener
{
	[progressListeners removeObject:theListener];
}

-(void)reportProgress:(NSUInteger)theValue max:(NSUInteger)theMax
{
	for (id<ProgressListener> p in progressListeners) {
		[p reportProgress:theValue max:theMax];
	}
}
@end
