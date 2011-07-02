//
//  SortingStrategy.h
//  SpringSort
//
//  Created by Eric Wolter on 02.07.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SortStep <NSObject>
-(NSArray *)sort:(NSArray *)items;
@end
