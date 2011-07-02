//
//  SbAppleIconTests.m
//  SpringSort
//
//  Created by Eric Wolter on 14.06.11.
//  Copyright 2011 private. All rights reserved.
//
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "SbAppleIconTests.h"
#import <plist/plist.h>
#import "TestUtility.h"
#import "SbAppleIcon.h"

@implementation SbAppleIconTests

- (void)setUp
{
    [super setUp];
	
	plist_t plist = [TestUtility plistFromTestFile:@"SbAppleIcon"];
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
	assertThat(icon, instanceOf([SbAppleIcon class]));
}

- (void)test_FromPlist_HasCorrectDisplayName
{
	assertThat(icon.displayName, is(@"Phone"));
}

-(void)test_FromPlist_HasCorrectDisplayIdentifier
{
	assertThat(icon.displayIdentifier, is(@"com.apple.mobilephone"));
}

-(void)test_FromPlist_HasCorrectBundleIdentifier
{
	assertThat(((SbAppIcon *)icon).bundleIdentifier, is(@"com.apple.mobilephone"));
}

@end
