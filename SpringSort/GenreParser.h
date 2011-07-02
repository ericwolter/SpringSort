//
//  GenreParser.h
//  SpringSort
//
//  Created by Eric Wolter on 07.06.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenreParser : NSObject {
@private
    NSDictionary *translate;
}

- (id)initWithLanguage:(NSString *)lang;
-(void)changeLanguage:(NSString *)lang;
-(NSString*)getGenreForId:(NSNumber *)genreId;
-(NSArray *)getGenresFromMetadata:(NSDictionary *)metadata;

@end
