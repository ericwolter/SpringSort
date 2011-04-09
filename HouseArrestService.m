//
//  HouseArrestService.m
//  SpringSort
//
//  Created by Eric Wolter on 04.04.11.
//  Copyright 2011 private. All rights reserved.
//

#import "HouseArrestService.h"
#import <libimobiledevice/house_arrest.h>
#import <libimobiledevice/afc.h>

@implementation HouseArrestService

-(id)initWithHouseArrestClient:(house_arrest_client_t)theClient
{
    self = [super init];
    if (self)
    {
        _client = theClient;
    }
    return self;
}

-(NSArray *)getGenres:(NSString *)bundleIdentifier
{
    // TODO: check for apple apps and web clips
    plist_t metadata = [self getMetadata:[bundleIdentifier cStringUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableArray *genreIds = [NSMutableArray array];
    if (!metadata) {
        return genreIds;
    }
    
    plist_t pGenreId = plist_dict_get_item(metadata, "genreId");
    if(pGenreId) {
        uint64_t val = 0;
        plist_get_uint_val(pGenreId, &val);
        [genreIds addObject:[NSNumber numberWithInt:val]];
    }
    
    plist_t pSubGenres = plist_dict_get_item(metadata, "subgenres");
    if(pSubGenres) {
        int count = plist_array_get_size(pSubGenres);
        for (int i = 0; i < count; i++) {
            plist_t pSubGenre = plist_array_get_item(pSubGenres, i);
            uint64_t val = 0;
            plist_get_uint_val(plist_dict_get_item(pSubGenre, "genreId"), &val);
            [genreIds addObject:[NSNumber numberWithInt:val]];
        }
    }
    
    plist_free(metadata);
    
    return genreIds;
}

-(plist_t)getMetadata:(const char *)bundleIdentifier
{
    if (house_arrest_send_command(_client, "VendContainer", bundleIdentifier) != HOUSE_ARREST_E_SUCCESS)
    {
        NSLog(@"client, command, or appid is invalid, or incorrect mode!");
        return nil;
    }
    
    plist_t response = NULL;
    if (house_arrest_get_result(_client, &response))
    {
        NSLog(@"could not get vendor container");
        return nil;
    }
    plist_free(response);
    
    afc_client_t afcClient = NULL;
    if(afc_client_new_from_house_arrest_client(_client, &afcClient) != AFC_E_SUCCESS)
    {
        NSLog(@"could not get afc client");
        return nil;
    }
    
    char **fileInfo = NULL;
    if ((afc_get_file_info(afcClient, "iTunesMetadata.plist", &fileInfo) != AFC_E_SUCCESS) || !fileInfo)
    {
        NSLog(@"could not get file info");
        afc_client_free(afcClient);
        return nil;
    }
    
    uint32_t fileSize = 0;
    for (int i = 0; fileInfo[i]; i+=2) {
        if (!strcmp(fileInfo[i], "st_size")) {
            fileSize = atoi(fileInfo[i+1]);
            break;
        }
    }
    
    int i = 0;
    while (fileInfo[i]) {
        free(fileInfo[i]);
        i++;
    }
    free(fileInfo);
    
    uint64_t handle = 0;
    
    if (afc_file_open(afcClient, "iTunesMetadata.plist", AFC_FOPEN_RDONLY, &handle) != AFC_E_SUCCESS)
    {
        NSLog(@"could not open file");
        afc_client_free(afcClient);
        return nil;
    }
    
    char *plistString = NULL;
    plistString = (char *) malloc(sizeof(char) * (fileSize + 1));
    
    uint32_t amount = 0;
    if (afc_file_read(afcClient, handle, plistString, fileSize, &amount) != AFC_E_SUCCESS)
    {
        NSLog(@"could not read file");
        afc_client_free(afcClient);
        free(plistString);
        return nil;
    }
    
    afc_file_close(afcClient, handle);
    
    plist_t metadata = NULL;
    if (memcmp(plistString, "bplist00", 8) == 0) {
        plist_from_bin(plistString, fileSize, &metadata);
    }
    else {
        plist_from_xml(plistString, fileSize, &metadata);
    }
    
    afc_client_free(afcClient);
    free(plistString);
    
    return metadata;
}

@end
