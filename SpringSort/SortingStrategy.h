//
//  SortingStrategy.h
//  SpringSort
//
//  Created by Eric Wolter on 07.05.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpringSortController.h"
#import "SbState.h"

@class SpringSortController;

@interface SortingStrategy : NSObject {
@private
	NSString *name;
	NSString *description;
    SpringSortController *controller;
}

@property (nonatomic, assign) SpringSortController *controller;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;

- (id)initWithController:(SpringSortController *)theController;
- (SbState *)newSortedState:(SbState *)sourceState;
- (NSArray *)sortByDisplayName:(NSArray *)array;

@end
