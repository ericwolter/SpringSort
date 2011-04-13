//
//  UsbUtility.h
//  SpringSort
//
//  Created by Eric Wolter on 04.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UsbUtility : NSObject {
    
}

+(NSArray *)deviceList;
+(NSString *)firstDeviceUuid;

@end
