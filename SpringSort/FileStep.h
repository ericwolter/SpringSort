//
//  OrganizingStrategy.h
//  SpringSort
//
//  Created by Eric Wolter on 02.07.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FileStep <NSObject>
-(NSArray *)file:(NSArray *)items;
@end
