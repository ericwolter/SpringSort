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
#import "PListUtility.h"

@implementation SpringSortAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
    Device *d = [[Device alloc] initWithUuid:[Device getFirstDevice]];
    
    if (d)
    {
        SpringBoard *b = [[SpringBoard alloc] init];
        
        plist_t old_iconstate = [d device_sbs_get_iconstate];
        [b fillWith:old_iconstate];
        
        plist_t new_iconstate = [b export];
        
        NSString* old_xml = [PListUtility toXml:old_iconstate];
        NSString* new_xml = [PListUtility toXml:new_iconstate];
        
        if ([old_xml isEqualToString:new_xml])
        {
            NSLog(@"MATCH!");
        }
        else
        {
            NSLog(old_xml);
            NSLog(@"#########################");
            NSLog(new_xml);
        }
    
        [b release];
    }   
    
    [d release];
}

@end
