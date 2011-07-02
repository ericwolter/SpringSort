//
//  SbIcon.h
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <plist/plist.h>
#import "SbSerializable.h"

@interface SbIcon : NSObject<SbSerializable> {
	plist_t node;
	NSString *displayName;
	NSString *displayIdentifier;
	NSArray *genres;
	NSImage *icon;
}

@property (nonatomic, assign) plist_t node;
@property (nonatomic, readonly) NSString* displayName;
@property (nonatomic, readonly) NSString* displayIdentifier;
@property (nonatomic, retain) NSArray* genres;
@property (nonatomic, retain) NSImage* icon;
@property (nonatomic, readonly) NSString* primaryGenre;

+(NSString *)extractDisplayName:(plist_t)thePlist;
+(NSString *)extractDisplayIdentifier:(plist_t)thePlist;

@end
