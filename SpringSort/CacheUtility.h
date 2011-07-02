//
//  CacheUtility.h
//  SpringSort
//
//  Created by Eric Wolter on 07.06.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <plist/plist.h>
#import "GenreParser.h"
#import	"SbIcon.h"
#import "SbAppIcon.h"

@interface CacheUtility : NSObject {
@private
	NSString *_rootPath;
	NSMutableDictionary *_icons;
	NSMutableDictionary *_genres;
}

-(NSImage *)getImageForIcon:(SbIcon *)icon;
-(NSDictionary *)getMetadataForIcon:(SbAppIcon *)icon;
-(NSArray *)getGenresForIcon:(SbAppIcon *)icon;

-(void)saveImage:(NSImage *)image ForIcon:(NSString *)identifier;
-(void)saveMetadata:(plist_t)metadata ForIcon:(NSString *)identifier;

@property (nonatomic, retain) GenreParser *parser; 

@end
