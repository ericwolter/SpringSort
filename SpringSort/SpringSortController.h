//
//  SpringSortController.h
//  SpringSort
//
//  Created by Eric Wolter on 19.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <plist/plist.h>

@class Device;
@class SbState;
@class SbIcon;
@class SbContainer;

@interface SpringSortController : NSObject {
@private
    Device *device;
	SbState *state;
	NSMutableDictionary *cacheIcons;
	NSMutableDictionary *cacheGenres;
	
	NSImage *wallpaper;
}

@property (nonatomic, retain) Device *device;
@property (nonatomic, retain) SbState *state;

-(id)initWithDevice:(Device *)theDevice;
-(void)dealloc;
-(NSImage *)getImageForIcon:(SbIcon *)icon;
-(NSArray *)getGenresforIcon:(SbIcon *)icon;
-(NSImage *)getWallpaper;

@end
