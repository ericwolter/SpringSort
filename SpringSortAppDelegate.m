//
//  SpringSortAppDelegate.m
//  SpringSort
//
//  Created by Eric Wolter on 17.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SpringSortAppDelegate.h"
#import "Device.h"
#import "SpringBoard.h"

@implementation SpringSortAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
    Device *d = [[Device alloc] initWithUuid:[Device getFirstDevice]];
    
    SpringBoard *b = [[SpringBoard alloc] init];
    [b fillWith:[d device_sbs_get_iconstate]];
    
    [b release];
    [d release];
}

@end
