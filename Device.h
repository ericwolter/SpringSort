//
//  Device.h
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <libimobiledevice/lockdown.h>
#import <libimobiledevice/sbservices.h>
#import <libimobiledevice/house_arrest.h>

#import "SpringBoardService.h"
#import "HouseArrestService.h"

@interface Device : NSObject {
    idevice_t _device;
    lockdownd_client_t _lockdownd;
    sbservices_client_t _springBoardClient;
    house_arrest_client_t _houseArrestClient;
}

@property (nonatomic, copy) NSString* uuid;
@property (nonatomic, retain) SpringBoardService* springBoardService;
@property (nonatomic, retain) HouseArrestService* houseArrestService;

-(id)initWithUuid: (NSString *)theUuid;
-(void)dealloc;
-(BOOL)restart;
-(void)clean;
-(void)deviceStart;
-(void)lockdownStart;
-(void)springBoardStart;
-(void)houseArrestStart;
-(void)houseArrestRestart;

@end
