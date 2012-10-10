//
//  AdPSAXParser.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/27/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "Defs.h"
#import "NSStringAdditions.h"
#import "GlobalFunctions.h"
#import "CategoryMatcher.h"
#import "ParsingHelper.h"
#import "PSAXAdParser.h"
#import "AdData.h"
#import "ParsedDataFields.h"

@interface PSAXAdParser ()
/**
 Converts result array to dictionary:
 fieldname: [data]
*/
- (NSDictionary*) createDictioanryFromArray:(NSArray*)resultArray;

- (NSString*) parseLocationFromDictionary:(NSDictionary*)dict defaultLocation:(NSString*)defLocation andUnparsed:(NSString*)unparsed;

- (NSString*) parseBodyFromDictionary:(NSDictionary*)dict andUnparsed:(NSString*)unparsed;

- (NSString*) parseMailtoFromDictionary:(NSDictionary*)dict andUnparsed:(NSString*)unparsed;

- (NSString*) parsePostingIDFromDictionary:(NSDictionary*)dict andUnparsed:(NSString*)unparsed;

- (NSArray*) parseImagesFromDictionary:(NSDictionary*)dict andUnparsed:(NSString*)unparsed;

- (NSDate*) parseDateFromDictionary:(NSDictionary*)dict andUnparsed:(NSString*)unparsed;
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
    
    //NSLog(@"Result array %@", resultArray);

    NSDictionary* resultDict = [self createDictioanryFromArray:resultArray];
    NSArray* unparsedArray = [resultDict objectForKey:FIELD_AD_UNPARSED];
    NSString* unparsed = nil;
    if (nil != unparsedArray && [unparsedArray count] > 0)
        unparsed = [[unparsedArray objectAtIndex:0] objectForKey:kDataKey];
    
    AdData* adData = [self.requestInfo objectForKey:KEY_AD_DATA];
    if (nil==adData) {
        adData = [[[AdData alloc] init] autorelease];
    }
	adData.link = [self URL];
    
    //extract from title price and location and cleanup title
    NSString* title = nil;
    NSArray *item = [resultDict objectForKey:FIELD_AD_TITLE];
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
    
    adData.place = [self parseLocationFromDictionary:resultDict defaultLocation:place andUnparsed:unparsed];
    
    adData.body = [self parseBodyFromDictionary:resultDict andUnparsed:unparsed];
    
    adData.postingID = [self parsePostingIDFromDictionary:resultDict andUnparsed:unparsed];
    
    
    adData.imageURLs = [self parseImagesFromDictionary:resultDict andUnparsed:unparsed];
    
    adData.date = [self parseDateFromDictionary:resultDict andUnparsed:unparsed];
    
    //the same is true for descr as well;
	[adData descr];
	//the same is true for relativeTime
	[adData relativeTime];
	//the same is true for phone
	[adData phone];
    
    adData.mailto = [self parseMailtoFromDictionary:resultDict andUnparsed:unparsed];
    
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

- (NSString*)parseBodyFromDictionary:(NSDictionary*)dict andUnparsed:(NSString*)unparsed {
    NSString* body = nil;
    NSArray* bodies = [dict objectForKey:FIELD_AD_BODY];
    if (nil != bodies) {
        body = [[bodies objectAtIndex:0] objectForKey:kDataKey];
    } else {
        body = [self getDataFromDict:nil withKey:FIELD_AD_BODY withUnparsedData:unparsed andRegexpKey:FIELD_AD_BODY];
    }
    return body;
}

NSString* const LOCATION_PREFIX = @"Location: ";
unsigned long const LOCATION_PREFIX_LEN = 10;

- (NSString*)parseLocationFromDictionary:(NSDictionary*)dict defaultLocation:(NSString*)defLocation andUnparsed:(NSString*)unparsed {
    NSString* location;
    location = @"";
    NSArray* locs = [dict objectForKey:FIELD_AD_LOCATION];
    if (nil != locs) {
        for(id locItem in locs)
        {
            NSString* l = [locItem objectForKey:kDataKey];
            if ([l hasPrefix:LOCATION_PREFIX])
            {
                location = [l substringFromIndex:LOCATION_PREFIX_LEN];
                break;
            }
        }
    } else {
        location = [self getDataFromDict:nil withKey:FIELD_AD_LOCATION withUnparsedData:unparsed andRegexpKey:FIELD_AD_LOCATION];
    }
    return [location length] > 0 ? location : defLocation;
}

- (NSString*)parseMailtoFromDictionary:(NSDictionary*)dict andUnparsed:(NSString*)unparsed {
    NSString* mailto = nil;
    NSArray* mailtos = [dict objectForKey:FIELD_AD_MAILTO];
    if (nil != mailtos) {
        mailto = [[mailtos objectAtIndex:0] objectForKey:kDataKey];
    } else {
        mailto = [self getDataFromDict:nil withKey:FIELD_AD_MAILTO withUnparsedData:unparsed andRegexpKey:FIELD_AD_MAILTO];
    }
    return mailto;
}


NSString* const POSTINGID_PREFIX = @"PostingID: ";
unsigned long const POSTINGID_PREFIX_LEN = 11;

- (NSString*)parsePostingIDFromDictionary:(NSDictionary*)dict andUnparsed:(NSString*)unparsed {
    NSString* postingId = nil;
    NSArray* ids = [dict objectForKey:FIELD_AD_POSTINGID];
    
    if (nil != ids){
        postingId = [[ids objectAtIndex:0] objectForKey:kDataKey];
    } else {
        postingId = [self getDataFromDict:nil withKey:FIELD_AD_POSTINGID withUnparsedData:unparsed andRegexpKey:FIELD_AD_POSTINGID];
    }
    
    if (nil!=postingId && [postingId hasPrefix:POSTINGID_PREFIX])
        postingId = [postingId substringFromIndex:POSTINGID_PREFIX_LEN];
    return postingId;
}

- (NSArray*)parseImagesFromDictionary:(NSDictionary*)dict andUnparsed:(NSString*)unparsed {
    NSMutableArray* images = [NSMutableArray array];
    NSArray* imgs = [dict objectForKey:FIELD_AD_IMAGES];
    for(id img in imgs)
    {
        NSString *i = [img objectForKey:kDataKey];
        if (IsStringWithAnyText(i)) {
            [images addObject:i];
        }
    }
    return images;
}

NSString* const DATE_PREFIX = @"Date: ";
unsigned long const DATE_PREFIX_LEN = 6;

- (NSDate*) parseDateFromDictionary:(NSDictionary*)dict andUnparsed:(NSString*)unparsed {
    
    NSDate* adDate = nil;
    NSString* dateString = nil;
    NSArray* dates = [dict objectForKey:FIELD_AD_DATE];
    if (nil != dates){
        dateString = [[dates objectAtIndex:0] objectForKey:kDataKey];
    } else {
        dateString = [self getDataFromDict:nil withKey:FIELD_AD_DATE withUnparsedData:unparsed andRegexpKey:FIELD_AD_DATE];
    }
    if (nil!=dateString && [dateString hasPrefix:DATE_PREFIX])
        dateString = [dateString substringFromIndex:DATE_PREFIX_LEN];
    if (IsStringWithAnyText(dateString)) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:DATE_FORMAT_AD];
		NSLocale* enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
		assert(enUSPOSIXLocale != nil);
		[formatter setLocale:enUSPOSIXLocale];
        [enUSPOSIXLocale release];
        enUSPOSIXLocale = nil;
   		adDate = [formatter dateFromString:dateString];
        [formatter release];
        if (!adDate) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:DATE_FORMAT_AD];
            adDate = [dateFormatter dateFromString:dateString];
            [dateFormatter release];
        }
 	}
    return adDate;
}

@end
