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
    }
    
    return self;
}

-(void)download
{
	NSArray *icons = [self getIconsToSort];
	
	NSUInteger count = 0;
	NSUInteger total = [icons count];
	for(SbIcon *icon in icons) {
		//NSLog(@"Preloading %@",icon.displayName);
		if([icon isKindOfClass:[SbWebIcon class]]) {
			icon.icon = [self getImageForIcon:icon];
			icon.genres = [NSArray arrayWithObject:@"Bookmarks"];
		} else if ([icon isKindOfClass:[SbAppleIcon class]]) {
			icon.icon = [self getImageForIcon:icon];
			icon.genres = [NSArray arrayWithObject:@"Apple"];
		} else if ([icon isKindOfClass:[SbStoreIcon class]]) {
			SbStoreIcon *storeIcon = (SbStoreIcon *)icon;
			
			plist_t deviceMetadata = [self.device.houseArrestService getMetadata:[storeIcon.bundleIdentifier cStringUsingEncoding:NSUTF8StringEncoding]];
			
			BOOL reload = NO;
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
				storeIcon.icon = [self getImageForIcon:storeIcon];
			} else {
				storeIcon.icon = [cache getImageForIcon:storeIcon];
			}
			
			// set genre
			storeIcon.genres = [cache getGenresForIcon:storeIcon];
		}
		
		count = count + 1;
		[self reportProgress:count max:total];
	}
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

-(NSArray *)getIconsToSort
{
	NSMutableArray *flatten = [NSMutableArray array];
	
	for (int i = 1; i < [self.state.mainContainer.items count]; i++) {
		[Utilities flatten:[self.state.mainContainer.items objectAtIndex:i] IntoArray:flatten];
	}
	
	return flatten;
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
