//
//  SpringBoard.h
//  SpringSort
//
//  Created by Eric Wolter on 23.03.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libimobiledevice/sbservices.h>

@interface SpringBoard : NSObject {
    
}

@property (nonatomic, assign) NSMutableArray *pages;

-(id)init;
-(void)dealloc;
- (void)fillWith:(plist_t) plist;
- (plist_t)export;

@end
