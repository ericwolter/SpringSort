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
#import "PlistUtility.h"

static NSString *cachePath;

@interface SpringSortController()
-(NSString *)getCachePathForIconImage:(SbIcon *)icon;
-(NSImage *)getImageFromFileSystemCache:(SbIcon *)icon;
-(void)saveImageToFileSystemCache:(NSImage *)image toPath:(NSString *)path;
-(NSArray *)getGenresFromFileSystemCache:(SbIcon*)icon;
-(NSArray *)parseGenres:(plist_t)metadata;
-(void)saveMetadataToFileSystemCache:(plist_t)metadata toPath:(NSString *)path;
-(NSString *)getCachePathForIconMetadata:(SbIcon *)icon;
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
			cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];
		}
		
		NSFileManager *fileManager= [NSFileManager defaultManager]; 
		if(![fileManager fileExistsAtPath:cachePath isDirectory:nil])
			if(![fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL])
				NSLog(@"Error: Create folder failed %@", cachePath);
		
		[cachePath retain];
		
		pageStates = [[NSMutableDictionary alloc] init];
		[pageStates setObject:[NSNumber numberWithInt:PageIsExcluded] forKey:[NSNumber numberWithInt:0]];
    }
    
    return self;
}

- (void)dealloc
{
	[cachePath release];
	[cacheIcons release];
	[cacheGenres release];
	[wallpaper release];
	[pageStates release];
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
	NSString *filePath = [cachePath stringByAppendingPathComponent:icon.displayIdentifier];
	
	NSFileManager *fileManager= [NSFileManager defaultManager]; 
	if(![fileManager fileExistsAtPath:filePath isDirectory:nil])
		if(![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:NULL])
			NSLog(@"Error: Create folder failed %@", filePath);

	filePath = [filePath stringByAppendingPathComponent:@"artwork"];
	filePath = [filePath stringByAppendingPathExtension:@"png"];
	
	return filePath;
}

-(NSString *)getCachePathForIconMetadata:(SbIcon *)icon
{
	NSString *filePath = [cachePath stringByAppendingPathComponent:icon.displayIdentifier];
	
	NSFileManager *fileManager= [NSFileManager defaultManager]; 
	if(![fileManager fileExistsAtPath:filePath isDirectory:nil])
		if(![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:NULL])
			NSLog(@"Error: Create folder failed %@", filePath);
	
	filePath = [filePath stringByAppendingPathComponent:@"metadata"];
	filePath = [filePath stringByAppendingPathExtension:@"plist"];
	
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

-(void)saveMetadataToFileSystemCache:(plist_t)metadata toPath:(NSString *)path
{
	NSString *xml = [PlistUtility toString:metadata];
	[xml writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
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
		NSArray *genreIDs = [[NSMutableArray alloc] init];
		
		genreIDs = [self getGenresFromFileSystemCache:icon];
		if (!genreIDs) {
			plist_t metadata = [self.device.houseArrestService getMetadata:[icon.bundleIdentifier cStringUsingEncoding:NSUTF8StringEncoding]];
			if (metadata) {
				genreIDs = [self parseGenres:metadata];
				[self saveMetadataToFileSystemCache:metadata toPath:[self getCachePathForIconMetadata:icon]];
				plist_free(metadata);
			}
		}
		
		if ([genreIDs count] > 0) {
			genres = [NSMutableArray array];
			for (NSNumber *genreId in genreIDs) {
				NSString *genreText = [translate objectForKey:[genreId stringValue]];
				[genres addObject:genreText];
			}
			
			[cacheGenres setObject:genres forKey:icon.bundleIdentifier];
		}	
		
		[genreIDs release];
	}
										   
	[translate release];
	
	return genres;
}

-(NSArray *)getGenresFromFileSystemCache:(SbIcon*)icon
{
	NSString *metadataPath = [self getCachePathForIconMetadata:icon];
	if([[NSFileManager defaultManager] fileExistsAtPath:metadataPath]) {
		NSDictionary *metadata = [[NSDictionary alloc] initWithContentsOfFile:metadataPath];
		NSMutableArray *genreIds = [NSMutableArray array];
		
		if ([metadata objectForKey:@"genreId"]) {
			[genreIds addObject:[metadata objectForKey:@"genreId"]];
		}
		
		if ([metadata objectForKey:@"subgenres"]) {
			for (id subgenre in [metadata objectForKey:@"subgenres"]) {
				[genreIds addObject:subgenre];
			}
		}
		
		[metadata release];
		return genreIds;
	} else {
		return nil;
	}
}

-(NSArray *)parseGenres:(plist_t)metadata
{
	NSMutableArray *genreIds = [NSMutableArray array];
	if (!metadata) {
		return genreIds;
	}
	
	plist_t pGenreId = plist_dict_get_item(metadata, "genreId");
	
	if(pGenreId) {
		uint64_t val = 0;
		plist_get_uint_val(pGenreId, &val);
		[genreIds addObject:[NSNumber numberWithLongLong:val]];
	}
	
	plist_t pSubGenres = plist_dict_get_item(metadata, "subgenres");
	if(pSubGenres) {
		int count = plist_array_get_size(pSubGenres);
		for (int i = 0; i < count; i++) {
			plist_t pSubGenre = plist_array_get_item(pSubGenres, i);
			uint64_t val = 0;
			plist_get_uint_val(plist_dict_get_item(pSubGenre, "genreId"), &val);
			[genreIds addObject:[NSNumber numberWithLongLong:val]];
		}
	}
	
	return genreIds;
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

-(void)togglePageState:(int)pageIndex;
{
	NSNumber *pageNumber = [NSNumber numberWithInt:pageIndex];
	PageState pageState = [[pageStates objectForKey:pageNumber] intValue];
	if(pageState) {
		switch (pageState) {
			case PageIsExcluded:
				[pageStates setObject:[NSNumber numberWithInt:PageIsTargetOnly] forKey:pageNumber];
				break;
			case PageIsIncluded:
				[pageStates setObject:[NSNumber numberWithInt:PageIsExcluded] forKey:pageNumber];
				break;
			case PageIsTargetOnly:
				[pageStates setObject:[NSNumber numberWithInt:PageIsIncluded] forKey:pageNumber];
			default:
				break;
		}
	} else {
		[pageStates setObject:[NSNumber numberWithInt:PageIsExcluded] forKey:pageNumber];
	}
}

-(PageState)getPageState:(int)pageIndex
{
	return [[pageStates objectForKey:[NSNumber numberWithInt:pageIndex]] intValue];
}
@end
