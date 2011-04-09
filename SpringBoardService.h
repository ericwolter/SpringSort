//
//  SpringBoardService.h
//  SpringSort
//
//  Created by Eric Wolter on 04.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libimobiledevice/sbservices.h>

#import "SbState.h"

@interface SpringBoardService : NSObject {
    sbservices_client_t _client;
}

-(id)initWithSpringBoardClient:(sbservices_client_t)theClient;
-(plist_t)queryState;
-(void)writeState:(plist_t)plist;

@end
