//
//  SbFolder.h
//  SpringSort
//
//  Created by Eric Wolter on 06.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <plist/plist.h>

@interface SbFolder : NSObject {
    
}

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, copy) NSString *displayName;

+(SbFolder *)initFromPlist:(plist_t)plist;

-(void)dealloc;
-(plist_t)toPlist;

@end
