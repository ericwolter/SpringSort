//
//  SbFolder.h
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <plist/plist.h>

@interface SbContainer : NSObject {
    NSMutableArray* items;
}

@property (nonatomic, retain) NSMutableArray *items;

-(id)initFromPlist:(plist_t)plist;
-(void)dealloc;
-(plist_t)toPlist;

@end
