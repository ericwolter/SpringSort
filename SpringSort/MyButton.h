//
//  MyButton.h
//  SpringSort
//
//  Created by Eric Wolter on 09.05.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MyButton : NSButton {
@private
	NSTrackingArea *trackingArea;
}

@end
