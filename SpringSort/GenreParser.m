//
//  GenreParser.m
//  SpringSort
//
//  Created by Eric Wolter on 07.06.11.
//  Copyright 2011 private. All rights reserved.
//

#import "GenreParser.h"

@implementation GenreParser

- (id)init
{
	return [self initWithLanguage:@"en"];
}

- (id)initWithLanguage:(NSString *)lang
{
    self = [super init];
    if (self) {
		[self changeLanguage:lang];
    }
    
    return self;
}

- (void)dealloc
{
	[translate release];
    [super dealloc];
}

-(void)changeLanguage:(NSString *)lang
{
	NSString *name = [@"GenreID-" stringByAppendingString:lang];
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
	
	if(translate) {
		[translate release];
	}
	
	translate = [[NSDictionary alloc] initWithContentsOfFile:path];
}

-(NSString*)getGenreForId:(NSNumber *)genreId
{
	return [translate objectForKey:[genreId stringValue]];
}

-(NSArray *)getGenresFromMetadata:(NSDictionary *)metadata
{
	NSMutableArray *genres = [NSMutableArray array];
	if ([metadata objectForKey:@"genreId"]) {
		[genres addObject:[self getGenreForId:[metadata objectForKey:@"genreId"]]];
	}
	
	if ([metadata objectForKey:@"subgenres"]) {
		for (id subgenre in [metadata objectForKey:@"subgenres"]) {
			[genres addObject:[self getGenreForId:[metadata objectForKey:@"genreId"]]];
		}
	}
	
	return genres;
}

@end
