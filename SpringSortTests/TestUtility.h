//
//  TestUtility.h
//  SpringSort
//
//  Created by Eric Wolter on 14.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <plist/plist.h>

@interface TestUtility : NSObject {
@private
    
}

+(plist_t)plistFromTestFile:(NSString *)testFile;

@end
