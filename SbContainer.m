//
//  SbFolder.m
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SbContainer.h"

@implementation SbContainer

@synthesize items;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self.items release];
    [super dealloc];
}

@end
