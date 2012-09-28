//
//  AdPSAXParser.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/27/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "Defs.h"
#import "NSStringAdditions.h"
#import "CategoryMatcher.h"
#import "ParsingHelper.h"
#import "PSAXAdParser.h"
#import "AdData.h"

@interface PSAXAdParser ()
/**
 Converts result array to dictionary:
 fieldname: [data]
*/
- (NSDictionary*)createDictioanryFromArray:(NSArray*)resultArray;

- (NSString*)parseLocationFromDictionary:(NSDictionary*)dict defaultLocation:(NSString*)defLocation;

- (NSString*)parseMailtoFromDictionary:(NSDictionary*)dict;

- (NSString*)parsePostingIDFromDictionary:(NSDictionary*)dict;

- (NSArray*)parseImagesFromDictionary:(NSDictionary*)dict;
@end


@implementation PSAXAdParser

- (BOOL) canGetImages:(CategoryMatcher*) matcher {
    BOOL result = YES;
    //BOOL showPersonalsImages = [[ResourceManager instance] lifelikeappsAdminController].showImagesInPersonals;
    //if ([matcher isPersonals] && !showPersonalsImages) {
    //    result = NO;
    //}
    return result;
}

- (NSObject*) parseResultArray:(NSArray*)resultArray {

    NSDictionary* resultDict = [self createDictioanryFromArray:resultArray];
    
    AdData* adData = [self.requestInfo objectForKey:KEY_AD_DATA];
    if (nil==adData) {
        adData = [[[AdData alloc] init] autorelease];
    }
	adData.link = [self URL];
    
    //extract from title price and location and cleanup title
    NSString* title = nil;
    NSArray *item = [resultDict objectForKey:@"title"];
    if (nil != item)
        title = [[item objectAtIndex:0] objectForKey:kDataKey];
    
    ParsingHelper* parsingHelper = [[ParsingHelper alloc] init];
	NSString* place = [parsingHelper parseOutPlace:&title];
	if ([place isEqualToString:@"map"]) {
		place = [parsingHelper parseOutPlace:&title];
	}
    
	CategoryMatcher* matcher = [[CategoryMatcher alloc] initWithHref:[self.requestInfo objectForKey:KEY_TOP_CATEGORY_HREF]];
	adData.price = [parsingHelper parseOutPriceForTitle:&title withMatcher:matcher];
	[parsingHelper release];
    
    adData.title = title;
    
    adData.place = [self parseLocationFromDictionary:resultDict defaultLocation:place];
    
    adData.body = [[[resultDict objectForKey:@"body"] objectAtIndex:0] objectForKey:kDataKey];
    
    adData.postingID = [self parsePostingIDFromDictionary:resultDict];
    
    
    adData.imageURLs = [self parseImagesFromDictionary:resultDict];
    
    
    //the same is true for descr as well;
	[adData descr];
	//the same is true for relativeTime
	//[adData relativeTime];
	//the same is true for phone
	[adData phone];
    
    adData.mailto = [self parseMailtoFromDictionary:resultDict];
    
    [resultDict release];
    
    return adData;
}

- (NSDictionary*)createDictioanryFromArray:(NSArray*)resultArray {
    
    NSMutableDictionary* resultDict = [[NSMutableDictionary alloc] init];
    for(id item in resultArray)
    {
        NSString* fieldName = [item objectForKey:kFieldNameKey];
        NSMutableArray* itemArray = [resultDict objectForKey:fieldName];
        if (nil == itemArray)
        {
            itemArray = [NSMutableArray array];
            [resultDict setObject:itemArray forKey:fieldName];
        }
        [itemArray addObject:item];
    }
    return resultDict;
}


NSString* const LOCATION_PREFIX = @"Location: ";
unsigned long const LOCATION_PREFIX_LEN = 10;

- (NSString*)parseLocationFromDictionary:(NSDictionary*)dict defaultLocation:(NSString*)defLocation {
    NSString* location;
    location = @"";
    NSArray* locs = [dict objectForKey:@"location"];
    if (nil != locs)
        for(id locItem in locs)
        {
            NSString* l = [locItem objectForKey:kDataKey];
            if ([l hasPrefix:LOCATION_PREFIX])
            {
                location = [l substringFromIndex:LOCATION_PREFIX_LEN];
                break;
            }
        }
    return [location length] > 0 ? location : defLocation;
}

- (NSString*)parseMailtoFromDictionary:(NSDictionary*)dict {
    NSString* mailto = nil;
    NSArray* mailtos = [dict objectForKey:@"mailto"];
    if (nil != mailtos)
        mailto = [[mailtos objectAtIndex:0] objectForKey:kDataKey];
    return mailto;
}


NSString* const POSTINGID_PREFIX = @"PostingID: ";
unsigned long const POSTINGID_PREFIX_LEN = 11;

- (NSString*)parsePostingIDFromDictionary:(NSDictionary*)dict {
    NSString* postingId = nil;
    NSArray* ids = [dict objectForKey:@"postingid"];
    if (nil != ids)
    {
        postingId = [[ids objectAtIndex:0] objectForKey:kDataKey];
        if ([postingId hasPrefix:POSTINGID_PREFIX])
            postingId = [postingId substringFromIndex:POSTINGID_PREFIX_LEN];
    }
    return postingId;
}

- (NSArray*)parseImagesFromDictionary:(NSDictionary*)dict {
    NSMutableArray* images = [NSMutableArray array];
    NSArray* imgs = [dict objectForKey:@"images"];
    for(id img in imgs)
        [images addObject:[img objectForKey:kDataKey]];
    return images;
}

@end
