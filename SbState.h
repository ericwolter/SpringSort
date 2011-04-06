//
//  SpringBoard.h
//  SpringSort
//
//  Created by Eric Wolter on 23.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libimobiledevice/sbservices.h>

#import "SbContainer.h"

@interface SbState : NSObject {
    
}

@property (nonatomic, retain) SbContainer *mainContainer;

+(SbState*)initFromPlist:(plist_t)plist;

-(plist_t)toPlist;

+(plist_t)switchSbType:(plist_t)plist;

@end
