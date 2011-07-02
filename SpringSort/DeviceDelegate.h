//
//  DeviceListener.h
//  SpringSort
//
//  Created by Eric Wolter on 29.06.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DeviceDelegate <NSObject>

-(void)deviceAdded:(Device *)theDevice;
-(void)deviceRemoved:(Device *)theDevice;

@end