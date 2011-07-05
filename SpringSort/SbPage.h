//
//  SbPage.h
//  SpringSort
//
//  Created by Eric Wolter on 02.07.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SbContainer.h"

typedef enum{
	PageIsIncluded,
	PageIsExcluded,
	PageIsTargetOnly,
} PageState;

@interface SbPage : SbContainer {
@private
    PageState state;
}

@property (nonatomic, assign) PageState state;

@end
