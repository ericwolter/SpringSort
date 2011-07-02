//
//  CacheUtility.m
//  SpringSort
//
//  Created by Eric Wolter on 07.06.11.
//  Copyright 2011 private. All rights reserved.
//

#import "CacheUtility.h"
#import "PlistUtility.h"

@interface CacheUtility()
-(NSDictionary *)getMetadataForIconWith:(NSString *)identifier;
-(NSString *)getCachePathForIconImage:(NSString *)identifier;
-(NSString *)getCachePathForIconMetadata:(NSString *)identifier;
-(NSImage *)getImageFromFileSystemCache:(NSString *)identifier;
-(NSArray *)getGenresFromFileSystemCache:(NSString *)identifier;
-(NSDictionary *)getMetadataFromFileSystemCache:(NSString *)identifier;
-(void)saveImageToFileSystemCache:(NSImage *)image toPath:(NSString *)path;
-(void)saveMetadataToFileSystemCache:(plist_t)metadata toPath:(NSString *)path;
@end

@implementation CacheUtility

@synthesize parser;

- (id)init
{
    self = [super init];
    if (self) {
		self.parser = [[GenreParser alloc] init];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		if ([paths count])
		{
			NSString *bundleName =
			[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
			_rootPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];
		}
		
		NSFileManager *fileManager= [NSFileManager defaultManager]; 
		if(![fileManager fileExistsAtPath:_rootPath isDirectory:nil])
			if(![fileManager createDirectoryAtPath:_rootPath withIntermediateDirectories:YES attributes:nil error:NULL])
				NSLog(@"Error: Create folder failed %@", _rootPath);
		
		[_rootPath retain];
		
		_icons = [[NSMutableDictionary alloc] init];
		_genres = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
	self.parser = nil;
	
	[_icons release];
	for(NSString *identifier in [_genres allKeys]) {
		plist_free([_genres objectForKey:identifier]);
	}
	[_genres release];
    [super dealloc];
}

-(NSImage *)getImageForIcon:(SbIcon *)icon
{
	return [self getImageFromFileSystemCache:icon.displayIdentifier];
}

-(NSArray *)getGenresForIcon:(SbAppIcon *)icon
{
	return [self getGenresFromFileSystemCache:icon.bundleIdentifier];
}

-(NSDictionary *)getMetadataForIcon:(SbAppIcon *)icon
{
	return [self getMetadataFromFileSystemCache:icon.bundleIdentifier];
}

-(NSDictionary *)getMetadataForIconWith:(NSString *)identifier
{
	return [self getMetadataFromFileSystemCache:identifier];
}

-(NSString *)getCachePathForIconImage:(NSString *)identifier
{
	NSString *filePath = [_rootPath stringByAppendingPathComponent:identifier];
	
	NSFileManager *fileManager= [NSFileManager defaultManager]; 
	if(![fileManager fileExistsAtPath:filePath isDirectory:nil])
		if(![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:NULL])
			NSLog(@"Error: Create folder failed %@", filePath);
	
	filePath = [filePath stringByAppendingPathComponent:@"artwork"];
	filePath = [filePath stringByAppendingPathExtension:@"png"];
	
	return filePath;
}

-(NSString *)getCachePathForIconMetadata:(NSString *)identifier
{
	NSString *filePath = [_rootPath stringByAppendingPathComponent:identifier];
	
	NSFileManager *fileManager= [NSFileManager defaultManager]; 
	if(![fileManager fileExistsAtPath:filePath isDirectory:nil])
		if(![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:NULL])
			NSLog(@"Error: Create folder failed %@", filePath);
	
	filePath = [filePath stringByAppendingPathComponent:@"metadata"];
	filePath = [filePath stringByAppendingPathExtension:@"plist"];
	
	return filePath;
}

-(NSImage *)getImageFromFileSystemCache:(NSString *)identifier
{
	NSString *imagePath = [self getCachePathForIconImage:identifier];
	if([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
		NSImage *sourceImage = [[NSImage alloc] initWithContentsOfFile:imagePath];
		return [sourceImage autorelease];
	}
	
	return nil;
}

-(NSArray *)getGenresFromFileSystemCache:(NSString *)identifier
{
	NSDictionary *metadata = [self getMetadataForIconWith:identifier];
	if (metadata) {
		NSArray *genres = [self.parser getGenresFromMetadata:metadata];
		if (genres) {
			return genres;
		}
	}
	
	return nil;
}

-(NSDictionary *)getMetadataFromFileSystemCache:(NSString *)identifier
{
	NSString *metadataPath = [self getCachePathForIconMetadata:identifier];
	if([[NSFileManager defaultManager] fileExistsAtPath:metadataPath]) {
		NSDictionary *metadata = [NSDictionary dictionaryWithContentsOfFile:metadataPath];
		if(metadata) {
			return metadata;
		}
	}
	
	return nil;
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

-(void)saveImage:(NSImage *)image ForIcon:(NSString *)identifier
{
	[self saveImageToFileSystemCache:image toPath:[self getCachePathForIconImage:identifier]];
	[_icons setObject:image forKey:identifier];
}
-(void)saveMetadata:(plist_t)metadata ForIcon:(NSString *)identifier
{
	[self saveMetadataToFileSystemCache:metadata toPath:[self getCachePathForIconMetadata:identifier]];
}


@end
