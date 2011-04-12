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
#import "SbIcon.h"

@implementation SpringSortAppDelegate

@synthesize springBoardView;
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
    Device *d = [[Device alloc] initWithUuid:[UsbUtility firstDeviceUuid]];
    
    if (d)
	{
		NSImage *i = [d.springBoardService getWallpaper];
		
		springBoardView.image = i;
		[springBoardView setNeedsDisplay:YES];
//        plist_t old_state = [d.springBoardService queryState];
//        SbState *state = [[SbState alloc] initFromPlist:old_state];
//        
//        NSMutableArray *flat = [NSMutableArray array];
//        [SortAlgorithms flatten:state.mainContainer IntoArray:flat];
//        
//        for (SbIcon *icon in flat) {
//            icon.genreIds = [d.houseArrestService getGenres:icon.bundleIdentifier];
//            [d houseArrestRestart];
//        }
//        
//        [SortAlgorithms alphabetically:state];
////        [SortAlgorithms byGenreInFolders:state];
//        
//        NSLog(@"%@",[PListUtility toString:[state toPlist]]);
//        
//        [d.springBoardService writeState:[state toPlist]];
//            
//        [state release];
    }   
    
    [d release];
    NSLog(@"DONE!");
}

@end
