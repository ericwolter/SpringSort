//
//  SpringBoardView.h
//  SpringSort
//
//  Created by Eric Wolter on 12.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SbState.h"

@class SpringSortController;

@interface SpringBoardView : NSView {
@private
    SpringSortController *controller;
	SbState *state;
}

@property (nonatomic, retain) SpringSortController *controller;
@property (nonatomic, assign) SbState *state;

@end
