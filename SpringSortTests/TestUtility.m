//
//  TestUtility.m
//  SpringSort
//
//  Created by Eric Wolter on 14.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "TestUtility.h"

@implementation TestUtility

+(plist_t)plistFromTestFile:(NSString *)testFile
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"SbIcon_StoreApp" ofType:@"plist"];
	
	NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
	NSData *data = [handle readDataToEndOfFile];
	
	const void *bytes = [data bytes];
	uint32_t length = (uint32_t)[data length];

	plist_t result = NULL;
	if(memcmp(bytes, "bplist00", 8) == 0) {
		plist_from_bin(bytes, length, &result);
	} else {
		plist_from_xml(bytes, length, &result);
	}
	
	[handle closeFile];
	
	return result;
}

@end
