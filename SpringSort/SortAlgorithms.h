//
//  SortAlgorithms.h
//  SpringSort
//
//  Created by Eric Wolter on 02.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SbContainer.h"
#import "SbState.h"

@interface SortAlgorithms : NSObject {

}

+(void)alphabetically:(SbState *)state;
+(void)byGenreInFolders:(SbState *)state;
+(NSMutableArray *)alphabeticallyInFolders:(NSMutableArray *)pages;

@end
