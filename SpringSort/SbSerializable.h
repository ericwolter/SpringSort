//
//  SbSerializable.h
//  SpringSort
//
//  Created by Eric Wolter on 14.06.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <plist/plist.h>

@protocol SbSerializable <NSObject>

+(id)newFromPlist:(plist_t)thePlist;
-(plist_t)toPlist;

@end
