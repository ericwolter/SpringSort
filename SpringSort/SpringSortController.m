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
#import "Utilities.h"

static NSString *cachePathImages;

@interface SpringSortController()
-(NSString *)getCachePathForIconImage:(SbIcon *)icon;
-(NSImage *)getImageFromFileSystemCache:(SbIcon *)icon;
-(void)saveImageToFileSystemCache:(NSImage *)image toPath:(NSString *)path;
@end

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
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		if ([paths count])
		{
			NSString *bundleName =
			[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
			cachePathImages = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];
		}
		
		cachePathImages = [cachePathImages stringByAppendingPathComponent:@"images"];
		
		NSFileManager *fileManager= [NSFileManager defaultManager]; 
		if(![fileManager fileExistsAtPath:cachePathImages isDirectory:nil])
			if(![fileManager createDirectoryAtPath:cachePathImages withIntermediateDirectories:YES attributes:nil error:NULL])
				NSLog(@"Error: Create folder failed %@", cachePathImages);
		
		[cachePathImages retain];
		
		ignoredPages = [[NSMutableSet alloc] init];
		[ignoredPages addObject:[NSNumber numberWithInt:0]];
    }
    
    return self;
}

- (void)dealloc
{
	[cachePathImages release];
	[cacheIcons release];
	[cacheGenres release];
	[wallpaper release];
	[ignoredPages release];
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

-(NSString *)getCachePathForIconImage:(SbIcon *)icon
{
	NSString *filePath = [cachePathImages stringByAppendingPathComponent:icon.displayIdentifier];
	filePath = [filePath stringByAppendingPathExtension:@"png"];
	
	return filePath;
}

-(NSImage *)getImageFromFileSystemCache:(SbIcon *)icon
{
	NSString *imagePath = [self getCachePathForIconImage:icon];
	if([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
		NSImage *sourceImage = [[NSImage alloc] initWithContentsOfFile:imagePath];
		return [sourceImage autorelease];
	} else {
		return nil;
	}
}

-(void)saveImageToFileSystemCache:(NSImage *)image toPath:(NSString *)path
{
	NSData *bitmapData = [NSBitmapImageRep representationOfImageRepsInArray:[image representations] usingType:NSPNGFileType properties:nil];
	
	[bitmapData writeToFile:path atomically:YES];
}

-(NSImage *)getImageForIcon:(SbIcon *)icon
{
	NSImage *image = [cacheIcons objectForKey:icon.displayIdentifier];
	
	if(!image) {
		image = [self getImageFromFileSystemCache:icon];
		if(!image) {
			image = [self.device.springBoardService getIcon:[icon.displayIdentifier cStringUsingEncoding:NSUTF8StringEncoding]];
			[self saveImageToFileSystemCache:image toPath:[self getCachePathForIconImage:icon]];
		}
		[cacheIcons setObject:image forKey:icon.displayIdentifier]; 
	}
	
	return image;
}

-(NSArray *)getGenresforIcon:(SbIcon *)icon
{
	NSMutableArray *genres = [cacheGenres objectForKey:icon.bundleIdentifier];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"GenreID-en" ofType:@"plist"];
	NSDictionary *translate = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	if(!genres) {
		NSArray *genreIDs = [self.device.houseArrestService getGenres:[icon.bundleIdentifier cStringUsingEncoding:NSUTF8StringEncoding]];
		genres = [NSMutableArray array];
		for (NSNumber *genreId in genreIDs) {
			NSString *test = [translate objectForKey:[genreId stringValue]];
			[genres addObject:test];
		}
		
		if ([genres count] > 0) {
			[cacheGenres setObject:genres forKey:icon.bundleIdentifier];
		}
	}
										   
	[translate release];
	
	return genres;
}

-(NSArray *)getIconsToSort
{
	NSMutableArray *flatten = [NSMutableArray array];
	
	for (int i = 2; i < [self.state.mainContainer.items count]; i++) {
		[Utilities flatten:[self.state.mainContainer.items objectAtIndex:i] IntoArray:flatten];
	}
	
	return flatten;
}

-(void)writeState
{
	[self.device.springBoardService setState:[self.state toPlist]];
}

-(void)toggleIgnoredPage:(int)pageIndex;
{
	NSNumber *pageNumber = [NSNumber numberWithInt:pageIndex];
	if ([ignoredPages containsObject:pageNumber]) {
		[ignoredPages removeObject:pageNumber];
	} else {
		[ignoredPages addObject:pageNumber];
	}
}

-(BOOL)isPageIgnored:(int)pageIndex
{
	return [ignoredPages containsObject:[NSNumber numberWithInt:pageIndex]];
}
@end
