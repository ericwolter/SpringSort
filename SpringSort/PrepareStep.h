//
//  PrepareStep.h
//  SpringSort
//
//  Created by Eric Wolter on 02.07.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PrepareStep <NSObject>
-(NSArray *)prepare:(NSArray *)pages;
@end
