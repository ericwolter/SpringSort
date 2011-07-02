//
//  SbStateTests.m
//  SpringSort
//
//  Created by Eric Wolter on 15.06.11.
//  Copyright 2011 private. All rights reserved.
//
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "SbStateTests.h"
#import <plist/plist.h>
#import "TestUtility.h"

@implementation SbStateTests

- (void)setUp
{
    [super setUp];
	
	plist_t plist = [TestUtility plistFromTestFile:@"SbState"];
	state = [SbState newFromPlist:plist];
	plist_free(plist);
}

- (void)tearDown
{
	[state release];
    [super tearDown];
}

-(void)testSbState_FromPlist_NotNull
{
	assertThat(state, notNilValue());
}

-(void)testSbState_MainContainer_NotNull
{
	assertThat(state.mainContainer, notNilValue());
}

-(void)testSbState_PageCount_IsCorrect
{
	assertThatInteger([state.mainContainer.items count], is(equalToInteger(8)));
}

@end
