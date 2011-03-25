//
//  SbFolder.h
//  SpringSort
//
//  Created by Eric Wolter on 18.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SbItem.h"

@interface SbContainer : SbItem {
    
}

@property (nonatomic, assign) NSMutableArray *items;

-(id)init;
-(void)dealloc;

@end
