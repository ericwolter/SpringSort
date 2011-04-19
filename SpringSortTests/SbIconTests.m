//
//  SpringSortTests.m
//  SpringSortTests
//
//  Created by Eric Wolter on 13.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "SbIconTests.h"
#import	"SbIcon.h"
#import "TestUtility.h"

@implementation SbIconTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSbIcon_FromPlist_NotNull
{
	plist_t plist = [TestUtility plistFromTestFile:@"SbIcon_StoreApp"];
	SbIcon *icon = [[SbIcon alloc] initFromPlist:plist];
	free(plist);
	
	STAssertNotNil(icon, @"icon was nil", nil);
	
	[icon release];
}

- (void)testSbIcon_StoreAppFromPlist_CorrectDisplayName
{
	plist_t plist = [TestUtility plistFromTestFile:@"SbIcon_StoreApp"];
	SbIcon *icon = [[SbIcon alloc] initFromPlist:plist];
	free(plist);
	
	STAssertTrue([icon.displayName isEqualToString:@"Wunderlist"], @"display name was incorrect ; %@", icon.displayName);
	
	[icon release];
}

@end
