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
#import "AdResultsProcessor.h"
#import "AdData.h"
#import "ParsedDataFields.h"

//for kDataKey, kFieldKey - move to another file
#import "DataMap.h"

@interface AdResultsProcessor ()
/**
 Converts result array to dictionary:
 fieldname: [data]
*/
- (NSDictionary*) createDictionaryFromArray:(NSArray*)resultArray;

- (NSString*) parseDataFromDictionary:(NSDictionary*)dict byKey:(NSString*)dataKey;

- (NSArray*) parseImagesFromDictionary:(NSDictionary*)dict;

- (NSDate*) parseDateFromDictionary:(NSDictionary*)dict;

@end

@implementation AdResultsProcessor

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

    NSDictionary* resultDict = [self createDictionaryFromArray:resultArray];
    
    AdData* adData = [self.requestInfo objectForKey:KEY_AD_DATA];
    if (nil==adData) {
        adData = [[[AdData alloc] init] autorelease];
    }
	adData.link = [self URL];
    
    adData.title = [self parseDataFromDictionary:resultDict byKey:FIELD_AD_TITLE];
    
    adData.price = [self parseDataFromDictionary:resultDict byKey:FIELD_AD_PRICE];
    
    adData.place = [self parseDataFromDictionary:resultDict byKey:FIELD_AD_LOCATION];
    
    adData.body = [self parseDataFromDictionary:resultDict byKey:FIELD_AD_BODY];
    
    adData.postingID = [self parseDataFromDictionary:resultDict byKey:FIELD_AD_POSTINGID];
    
    adData.imageURLs = [self parseImagesFromDictionary:resultDict];
    
    adData.date = [self parseDateFromDictionary:resultDict];
    
    //parsing out the description - just call the property - it will parse the data by itself
	[adData descr];
	//the same is true for relativeTime
	[adData relativeTime];
	//the same is true for phone
	[adData phone];
    
    adData.mailto = [self parseDataFromDictionary:resultDict byKey:FIELD_AD_MAILTO];
    
    adData.replyURL = [self parseDataFromDictionary:resultDict byKey:FIELD_AD_REPLYURL];
    
    [resultDict release];
    
    return adData;
}

- (NSDictionary*)createDictionaryFromArray:(NSArray*)resultArray {
    
    NSMutableDictionary* resultDict = [[NSMutableDictionary alloc] init];
    for(id item in resultArray)
    {
        NSString* fieldName = [item objectForKey:kFieldNameKey];
        if (nil != fieldName) {
            NSMutableArray* itemArray = [resultDict objectForKey:fieldName];
            if (nil == itemArray)
            {
                itemArray = [NSMutableArray array];
                [resultDict setObject:itemArray forKey:fieldName];
            }
            [itemArray addObject:item];
        }
    }
    return resultDict;
}

- (NSString*) parseDataFromDictionary:(NSDictionary*)dict byKey:(NSString*)dataKey {
    NSString* data = nil;
    NSArray* datas = [dict objectForKey:dataKey];
    if (nil != datas)
        data = [[datas objectAtIndex:0] objectForKey:kDataKey];
    return data;
}

- (NSArray*)parseImagesFromDictionary:(NSDictionary*)dict {
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

- (NSDate*) parseDateFromDictionary:(NSDictionary*)dict {
    
    NSDate* adDate = nil;
    NSString* dateString = nil;
    NSArray* dates = [dict objectForKey:FIELD_AD_DATE];
    if (nil != dates){
        dateString = [[dates objectAtIndex:0] objectForKey:kDataKey];
    } 
    
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
