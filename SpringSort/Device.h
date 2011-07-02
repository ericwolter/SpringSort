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
@private
	NSString *uuid;
	NSString *name;
	idevice_t idevice;
	SpringBoardService* springBoardService;
	HouseArrestService* houseArrestService;
}

@property (nonatomic, copy) NSString* uuid;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, readonly) idevice_t idevice;
@property (nonatomic, retain) SpringBoardService* springBoardService;
@property (nonatomic, retain) HouseArrestService* houseArrestService;

-(id)initWithUuid: (NSString *)theUuid;
-(void)dealloc;
-(void)start;
-(uint16_t)startSpringBoard;
-(uint16_t)startHouseArrest;

@end
