//
//  SpringBoard.m
//  SpringSort
//
//  Created by Eric Wolter on 23.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SbState.h"
#import "SbContainer.h"
#import "SbFolder.h"
#import "SbIcon.h"

@implementation SbState

@synthesize mainContainer;

+(SbState*)initFromPlist:(plist_t)plist
{
    SbState* state = [[SbState alloc] init];
    state.mainContainer = [SbState switchSbType:plist];    
    
    return state;
}

- (void)dealloc
{
    self.mainContainer = nil;
    [super dealloc];
}

-(plist_t)toPlist
{
    return [self.mainContainer toPlist];
}

+(plist_t)switchSbType:(plist_t)plist
{
    if (plist_get_node_type(plist) == PLIST_ARRAY) {
        return [SbContainer initFromPlist:plist];
    }
    else {
        if(plist_dict_get_item(plist, "iconLists")) {
            return [SbFolder initFromPlist:plist];
        }
        else
        {
            return [SbIcon initFromPlist:plist];
        }
    }
        
}

@end
