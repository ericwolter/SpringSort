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

}

@property (nonatomic, assign) plist_t node;

+(SbIcon *)initFromPlist:(plist_t)plist;

-(void)dealloc;
-(plist_t)toPlist;

@end
