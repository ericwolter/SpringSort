//
//  SpringSortTests.m
//  SpringSortTests
//
//  Created by Eric Wolter on 13.04.11.
//  Copyright 2011 private. All rights reserved.
//
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "SbStoreIconTests.h"
#import <plist/plist.h>
#import "TestUtility.h"
#import "SbStoreIcon.h"

@implementation SbStoreIconTests

- (void)setUp
{
    [super setUp];
	
	plist_t plist = [TestUtility plistFromTestFile:@"SbStoreIcon"];
	icon = [SbIcon newFromPlist:plist];
	plist_free(plist);
}

- (void)tearDown
{
	[icon release];
    [super tearDown];
}

- (void)test_FromPlist_NotNull
{
	assertThat(icon, notNilValue());
}

-(void)test_FromPlist_HasCorrectType
{
	assertThat(icon, instanceOf([SbStoreIcon class]));
}

- (void)test_FromPlist_HasCorrectDisplayName
{
	assertThat(icon.displayName, is(@"Wunderlist"));
}

-(void)test_FromPlist_HasCorrectDisplayIdentifier
{
	assertThat(icon.displayIdentifier, is(@"com.6wunderkinder.wunderlistmobile"));
}

-(void)test_FromPlist_HasCorrectBundleIdentifier
{
	assertThat(((SbAppIcon *)icon).bundleIdentifier, is(@"com.6wunderkinder.wunderlistmobile"));
}

@end
