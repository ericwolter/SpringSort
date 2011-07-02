//
//  SbFolder.h
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <plist/plist.h>
#import "SbSerializable.h"

@interface SbContainer : NSObject <SbSerializable> {
    NSMutableArray* items;
}

@property (nonatomic, retain) NSMutableArray *items;
-(void)dealloc;
-(SbContainer *)copy;

@end
