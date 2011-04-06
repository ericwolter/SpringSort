//
//  HouseArrestService.m
//  SpringSort
//
//  Created by Eric Wolter on 04.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "HouseArrestService.h"

@implementation HouseArrestService

-(id)initWithHouseArrestClient:(house_arrest_client_t)theClient
{
    self = [super init];
    if (self)
    {
        _client = theClient;
    }
    return self;
}

@end
