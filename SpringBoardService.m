//
//  SpringBoardService.m
//  SpringSort
//
//  Created by Eric Wolter on 04.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SpringBoardService.h"

#import "SbContainer.h"

@implementation SpringBoardService

-(id)initWithSpringBoardClient:(sbservices_client_t)theClient
{
    self = [super init];
    if (self)
    {
        _client = theClient;
    }
    return self;
}

-(plist_t)queryState
{
    plist_t state = NULL;
    
    if (sbservices_get_icon_state(_client, &state, "2") != SBSERVICES_E_SUCCESS || !state)
    {
        NSLog(@"Could not get icon state!");
    }
    if (plist_get_node_type(state) != PLIST_ARRAY)
    {
        NSLog(@"icon state is not an array as expected");
    }
    
    return state;    
}


-(void)writeState:(plist_t)plist
{
    if (sbservices_set_icon_state(_client, plist) != SBSERVICES_E_SUCCESS)
    {
        NSLog(@"Could not set new icon state!");
    }
}

@end
