//
//  SbAppIcon.h
//  SpringSort
//
//  Created by Eric Wolter on 14.06.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SbIcon.h"

@interface SbAppIcon : SbIcon {
@private
   	NSString *bundleIdentifier; 
}

@property (nonatomic, readonly) NSString* bundleIdentifier;

@end
