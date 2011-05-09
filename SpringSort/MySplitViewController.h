//
//  MySplitViewController.h
//  SpringSort
//
//  Created by Eric Wolter on 03.05.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MySplitViewController : NSObject <NSSplitViewDelegate> {
@private
    NSSplitView *mySplitView;
}

@property (assign) IBOutlet NSSplitView *mySplitView;

-(IBAction)clickedToggle:(NSButton *)sender;
-(void)collapseRightView;
-(void)uncollapseRightView;

@end
