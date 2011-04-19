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
#import "Device.h"

@interface HouseArrestService()
-(void)getNewPort;
-(house_arrest_client_t)connect;
-(void)disconnect:(house_arrest_client_t)client;
-(afc_client_t)connectAfc:(const char *)bundleIdentifier;
-(void)disconnectAfc:(afc_client_t)clientAfc;
-(uint32_t)getFileSize:(afc_client_t)clientAfc;
-(plist_t)getMetadata:(const char *)bundleIdentifier;
@end

@implementation HouseArrestService

-(id)initOnDevice:(Device *)theDevice atPort:(int)thePort;
{
    self = [super init];
    if (self)
    {
		device = theDevice;
		port = thePort;
    }
    return self;
}

-(void)getNewPort
{
	port = [device startHouseArrest];
}

-(afc_client_t)connectAfc:(const char*)bundleIdentifier
{
	afc_client_t clientAfc;
	
	house_arrest_client_t client = [self connect];
	if(client) {
		if(house_arrest_send_command(client, "VendContainer", bundleIdentifier) != HOUSE_ARREST_E_SUCCESS) {
			NSLog(@"client, command, or appid is invalid, or incorrect mode!: %s", bundleIdentifier);
		} else {
			plist_t result;
			if(house_arrest_get_result(client, &result) != HOUSE_ARREST_E_SUCCESS || !result) {
				NSLog(@"could not get vendor container: %s", bundleIdentifier);
			} else {
				if(afc_client_new_from_house_arrest_client(client, &clientAfc) != AFC_E_SUCCESS) {
					NSLog(@"could not get afc client: %s", bundleIdentifier);
				}
			}
		}
	}
	
	[self disconnect:client];
	
	return clientAfc;
}

-(void)disconnectAfc:(afc_client_t)clientAfc
{
	if (clientAfc) {
		afc_client_free(clientAfc);
	}
}

-(uint32_t)getFileSize:(afc_client_t)clientAfc
{
	uint32_t fileSize = 0;
	
	char **fileInfo;
	if ((afc_get_file_info(clientAfc, "iTunesMetadata.plist", &fileInfo) != AFC_E_SUCCESS) || !fileInfo) {
		NSLog(@"could not get file info");
	} else {
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
	}	
	
	return fileSize;
}

-(plist_t)getMetadata:(const char *)bundleIdentifier
{
	plist_t metadata;
	
	afc_client_t clientAfc = [self connectAfc:bundleIdentifier];
	if(clientAfc) {
		uint32_t fileSize = [self getFileSize:clientAfc];
		if(fileSize > 0) {
			uint64_t handle;
			if(afc_file_open(clientAfc, "iTunesMetadata.plist", AFC_FOPEN_RDONLY, &handle) != AFC_E_SUCCESS) {
				NSLog(@"could not open metadata file: %s", bundleIdentifier);
			} else {
				char *plist;
				plist = (char *) malloc(sizeof(char) * (fileSize + 1));
				uint32_t amount;
				if (afc_file_read(clientAfc, handle, plist, fileSize, &amount) != AFC_E_SUCCESS) {
					NSLog(@"could not read metadata file: %s", bundleIdentifier);
				} else {
					afc_file_close(clientAfc, handle);
					
					if(memcmp(plist, "bplist00", 8) == 0) {
						plist_from_bin(plist, fileSize, &metadata);
					} else {
						plist_from_xml(plist, fileSize, &metadata);
					}
				}
				
				free(plist);
			}
		}
	}
	
	[self disconnectAfc:clientAfc];
	
	return metadata;
}

-(NSArray *)getGenres:(const char *)bundleIdentifier
{
	plist_t metadata = [self getMetadata:bundleIdentifier];
	
	NSMutableArray *genreIds = [NSMutableArray array];
	if (!metadata) {
		return genreIds;
	}
	
	plist_t pGenreId = plist_dict_get_item(metadata, "genreId");
	
	if(pGenreId) {
		uint64_t val = 0;
		plist_get_uint_val(pGenreId, &val);
		[genreIds addObject:[NSNumber numberWithLong:val]];
	}
	
	plist_t pSubGenres = plist_dict_get_item(metadata, "subgenres");
	if(pSubGenres) {
		int count = plist_array_get_size(pSubGenres);
		for (int i = 0; i < count; i++) {
			plist_t pSubGenre = plist_array_get_item(pSubGenres, i);
			uint64_t val = 0;
			plist_get_uint_val(plist_dict_get_item(pSubGenre, "genreId"), &val);
			[genreIds addObject:[NSNumber numberWithLong:val]];
		}
	}
	
	plist_free(metadata);
	
	return genreIds;
}

-(house_arrest_client_t)connect
{
	house_arrest_client_t client = NULL;
    if (house_arrest_client_new(device.idevice, port, &client) != HOUSE_ARREST_E_SUCCESS)
        NSLog(@"Could not connect to springboard service!");
	
	return client;
}

-(void)disconnect:(house_arrest_client_t)client
{
	if(client)
		house_arrest_client_free(client);
}

@end
