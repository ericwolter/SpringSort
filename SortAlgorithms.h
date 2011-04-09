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

+(void)flatten:(SbContainer *)container IntoArray:(NSMutableArray *)flat;
+(void)alphabetically:(SbState *)pages;
+(NSMutableArray *)alphabeticallyInFolders:(NSMutableArray *)pages;

@end
