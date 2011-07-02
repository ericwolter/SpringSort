//
//  ProgresssListener.h
//  SpringSort
//
//  Created by Eric Wolter on 01.07.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ProgressListener <NSObject>
-(void)reportProgress:(NSUInteger)theValue max:(NSUInteger)theMax;
@end
