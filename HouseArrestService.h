//
//  HouseArrestService.h
//  SpringSort
//
//  Created by Eric Wolter on 04.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libimobiledevice/house_arrest.h>

@interface HouseArrestService : NSObject {
    house_arrest_client_t _client;
}

-(id)initWithHouseArrestClient:(house_arrest_client_t)theClient;

@end
