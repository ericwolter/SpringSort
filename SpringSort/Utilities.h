//
//  Utilities.h
//  SpringSort
//
//  Created by Eric Wolter on 12.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SbContainer.h"
#import "SbPage.h"
#import "SbFolder.h"
#import "SbIcon.h"

@interface Utilities : NSObject {
@private
    
}

+(void)flatten:(SbContainer *)container IntoArray:(NSMutableArray *)flat;
+(plist_t)switchSbType:(plist_t)plist;

@end
