//
//  SbIcon.h
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SbItem.h"

@interface SbIcon : SbItem {

}

@property (nonatomic, retain) NSDate* iconModDate; 
@property (nonatomic, retain) NSString* bundleIdentifier; 
@property (nonatomic, retain) NSString* displayIdentifier; 

@end
