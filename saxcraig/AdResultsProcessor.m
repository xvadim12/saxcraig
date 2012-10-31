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
- (NSDictionary*) createDictioanryFromArray:(NSArray*)resultArray;

- (NSString*) parseLocationFromDictionary:(NSDictionary*)dict;

- (NSString*) parsePriceFromDictionary:(NSDictionary*)dict;

- (NSString*) parseBodyFromDictionary:(NSDictionary*)dict;

- (NSString*) parseMailtoFromDictionary:(NSDictionary*)dict;

- (NSString*) parsePostingIDFromDictionary:(NSDictionary*)dict;

- (NSString*) parseReplyURLFromDictionary:(NSDictionary*)dict;

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

    NSDictionary* resultDict = [self createDictioanryFromArray:resultArray];
    
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
    
    adData.title = title;
    
    adData.price = [self parsePriceFromDictionary:resultDict];
    
    adData.place = [self parseLocationFromDictionary:resultDict];
    
    adData.body = [self parseBodyFromDictionary:resultDict];
    
    adData.postingID = [self parsePostingIDFromDictionary:resultDict];
    
    
    adData.imageURLs = [self parseImagesFromDictionary:resultDict];
    
    adData.date = [self parseDateFromDictionary:resultDict];
    
    //the same is true for descr as well;
	[adData descr];
	//the same is true for relativeTime
	[adData relativeTime];
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

- (NSString*)parseBodyFromDictionary:(NSDictionary*)dict {
    NSString* body = nil;
    NSArray* bodies = [dict objectForKey:FIELD_AD_BODY];
    if (nil != bodies)
        body = [[bodies objectAtIndex:0] objectForKey:kDataKey];
    return body;
}

- (NSString*)parseLocationFromDictionary:(NSDictionary*)dict {
    NSString* location;
    location = @"";
    NSArray* locs = [dict objectForKey:FIELD_AD_LOCATION];
    if (nil != locs) {
        location = [[locs objectAtIndex:0] objectForKey:kDataKey];
    }
    return location;
}

- (NSString*)parsePriceFromDictionary:(NSDictionary*)dict {
    NSString* price = nil;
    NSArray* prices = [dict objectForKey:FIELD_AD_PRICE];
    if (nil != prices) {
        price = [[prices objectAtIndex:0] objectForKey:kDataKey];
    }
    return price;
}

- (NSString*)parseMailtoFromDictionary:(NSDictionary*)dict {
    NSString* mailto = nil;
    NSArray* mailtos = [dict objectForKey:FIELD_AD_MAILTO];
    if (nil != mailtos) {
        mailto = [[mailtos objectAtIndex:0] objectForKey:kDataKey];
    } 
    return mailto;
}

- (NSString*)parsePostingIDFromDictionary:(NSDictionary*)dict {
    NSString* postingId = nil;
    NSArray* ids = [dict objectForKey:FIELD_AD_POSTINGID];
    
    if (nil != ids){
        postingId = [[ids objectAtIndex:0] objectForKey:kDataKey];
    } 
    return postingId;
}

- (NSString*) parseReplyURLFromDictionary:(NSDictionary*)dict {
    NSString* replyURL = nil;
    NSArray* replyURLs = [dict objectForKey:FIELD_AD_POSTINGID];
    
    if (nil != replyURLs){
        replyURL = [[replyURLs objectAtIndex:0] objectForKey:kDataKey];
    }
    return replyURL;
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
