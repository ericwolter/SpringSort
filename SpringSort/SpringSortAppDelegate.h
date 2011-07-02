//
//  SpringSortAppDelegate.h
//  SpringSort
//
//  Created by Eric Wolter on 13.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SpringSortController.h"
#import "DeviceCentral.h"
#import "DeviceDelegate.h"
#import "ProgressListener.h"

@class SpringBoardView;

@interface SpringSortAppDelegate : NSObject <NSApplicationDelegate, DeviceDelegate, ProgressListener> {
@private
	NSWindow *window;
	SpringSortController *springSortController;
	NSMutableArray *sortingStrategies;
	DeviceCentral *deviceCentral;
	
	IBOutlet SpringBoardView *springBoardView;
	IBOutlet NSTextField *messageLabel;
	IBOutlet NSProgressIndicator *indeterminateProgress;
	IBOutlet NSProgressIndicator *loadingProgress;
}

@property (nonatomic, assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) SpringSortController *springSortController;
@property (nonatomic, retain) NSMutableArray *sortingStrategies;
@property (nonatomic, retain) DeviceCentral *deviceCentral;

- (IBAction)sortByAlphabet:(NSButton *)sender;
- (IBAction)sortByGenre:(NSButton *)sender;

- (IBAction)reloadClicked:(NSButton *)sender;
-(void)reload:(Device *)device;
@end
