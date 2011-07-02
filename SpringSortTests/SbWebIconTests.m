//
//  SbWebclipTests.m
//  SpringSort
//
//  Created by Eric Wolter on 15.06.11.
//  Copyright 2011 private. All rights reserved.
//
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "SbWebIconTests.h"
#import <plist/plist.h>
#import "TestUtility.h"
#import "SbWebIcon.h"

@implementation SbWebIconTests

- (void)setUp
{
    [super setUp];
	
	plist_t plist = [TestUtility plistFromTestFile:@"SbWebIcon"];
	icon = [SbIcon newFromPlist:plist];
	plist_free(plist);
}

- (void)tearDown
{
	[icon release];
    [super tearDown];
}

- (void)testSbAppleIcon_FromPlist_NotNull
{
	assertThat(icon, notNilValue());
}

-(void)test_FromPlist_HasCorrectType
{
	assertThat(icon, instanceOf([SbWebIcon class]));
}

- (void)test_FromPlist_HasCorrectDisplayName
{
	assertThat(icon.displayName, is(@"BitBucket"));
}

-(void)test_FromPlist_HasCorrectDisplayIdentifier
{
	assertThat(icon.displayIdentifier, is(@"7687204625474EA39368D6184E14ACEE"));
}

@end
