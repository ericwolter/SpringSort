//
//  SbFolder.h
//  SpringSort
//
//  Created by Eric Wolter on 06.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SbContainer.h"
#import <plist/plist.h>

@interface SbFolder : SbContainer {
	NSString* displayName;
}

@property (nonatomic, copy) NSString *displayName;

@end
