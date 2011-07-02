//
//  SpringBoard.h
//  SpringSort
//
//  Created by Eric Wolter on 23.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libimobiledevice/sbservices.h>

#import "SbSerializable.h"
#import "SbContainer.h"

@interface SbState : NSObject<SbSerializable> {
	SbContainer* mainContainer;
}

@property (nonatomic, retain) SbContainer *mainContainer;

-(void)dealloc;
-(SbState *)copy;

@end
