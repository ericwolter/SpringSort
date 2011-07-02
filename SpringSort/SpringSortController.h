//
//  SpringSortController.h
//  SpringSort
//
//  Created by Eric Wolter on 19.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <plist/plist.h>
#import "CacheUtility.h"
#import "ProgressListener.h"

@class Device;
@class SbState;
@class SbIcon;
@class SbContainer;

@interface SpringSortController : NSObject {
@private
    Device *device;
	SbState *state;
	
	NSImage *wallpaper;
	CacheUtility *cache;
	
	NSMutableArray *progressListeners;
}

@property (nonatomic, retain) Device *device;
@property (nonatomic, retain) SbState *state;

-(id)initWithDevice:(Device *)theDevice;
-(void)dealloc;
-(NSImage *)getImageForIcon:(SbIcon *)icon;
-(NSImage *)getWallpaper;

-(void)writeState;
-(NSArray *)getIconsToSort;

-(void)togglePageState:(NSUInteger)pageIndex;

-(void)download;

-(void)addProgressListener:(id<ProgressListener>)theListener;
-(void)removeProgressListener:(id<ProgressListener>)theListener;
-(void)reportProgress:(NSUInteger)theValue max:(NSUInteger)theMax;
@end
