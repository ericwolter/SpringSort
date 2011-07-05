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
#import "Utilities.h"

@implementation SbState

@synthesize mainContainer;

+(id)newFromPlist:(plist_t)thePlist
{
	SbState *newState = [[SbState alloc] init];
	
	if(newState) {
		newState.mainContainer = [Utilities switchSbType:thePlist];
	}
	
	return newState;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        self.mainContainer = [[SbContainer alloc] init];
    }
    return self;    
}

- (void)dealloc
{
    self.mainContainer = nil;
    [super dealloc];
}

-(id)copy
{
	SbState *newState = [[SbState alloc] init];
	newState.mainContainer = [self.mainContainer copy];
	return newState;
}

-(plist_t)toPlist
{
    return [self.mainContainer toPlist];
}

@end
