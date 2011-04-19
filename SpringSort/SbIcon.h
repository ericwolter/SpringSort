//
//  SbIcon.h
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <plist/plist.h>

@interface SbIcon : NSObject {
	plist_t node;
	NSArray* genreIds;
}

@property (nonatomic, assign) plist_t node;
@property (nonatomic, readonly) NSString* displayName;
@property (nonatomic, readonly) NSString* bundleIdentifier;
@property (nonatomic, retain) NSArray* genreIds; 

-(id)initFromPlist:(plist_t)plist;
-(void)dealloc;
-(plist_t)toPlist;

@end