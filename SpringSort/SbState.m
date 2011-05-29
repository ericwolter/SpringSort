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

-(id)initFromPlist:(plist_t)plist
{
	self = [super init];
	if (self) {
		self.mainContainer = [Utilities switchSbType:plist];
	}
	return self;
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

-(plist_t)toPlist
{
    return [self.mainContainer toPlist];
}

@end
