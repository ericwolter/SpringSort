//
//  SpringSortAppDelegate.h
//  SpringSort
//
//  Created by Eric Wolter on 13.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SpringSortController.h"

@class SpringBoardView;

@interface SpringSortAppDelegate : NSObject <NSApplicationDelegate> {
@private
	NSWindow *window;
	SpringBoardView *springBoardView;
	SpringSortController *springSortController;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SpringBoardView *springBoardView;
@property (nonatomic, retain) SpringSortController *springSortController;
@property (nonatomic, retain) NSMutableArray *sortingStrategies;

- (IBAction)sortByAlphabet:(NSButton *)sender;
- (IBAction)sortByGenre:(NSButton *)sender;
@end
