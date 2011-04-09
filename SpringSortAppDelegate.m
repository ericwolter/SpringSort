//
//  SpringSortAppDelegate.m
//  SpringSort
//
//  Created by Eric Wolter on 17.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SpringSortAppDelegate.h"
#import "UsbUtility.h"
#import "Device.h"
#import "SbState.h"
#import "PListUtility.h"
#import "SortAlgorithms.h"

@implementation SpringSortAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
    Device *d = [[Device alloc] initWithUuid:[UsbUtility firstDeviceUuid]];
    
    if (d)
    {
        plist_t old_state = [d.springBoardService queryState];
        SbState *state = [SbState initFromPlist:old_state];
        
        plist_t new_state = [state toPlist];
        
        NSString* old_xml = [PListUtility toString:old_state];
        NSString* new_xml = [PListUtility toString:new_state];
        
        if ([old_xml isEqualToString:new_xml])
        {
            NSLog(@"MATCH!");
        }
        else
        {
            NSLog(@"%@", old_xml);
            NSLog(@"#########################");
            NSLog(@"%@", new_xml);
        }
        
        [SortAlgorithms alphabetically:state];
        [d.springBoardService writeState:[state toPlist]];
        
        [state release];
    }   
    
    [d release];
    NSLog(@"DONE!");
}

@end
