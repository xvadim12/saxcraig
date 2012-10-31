//
//  AdListPSAXParser.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/28/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "Defs.h"
#import "GlobalFunctions.h"
#import "URLDefs.h"
#import "AdData.h"
#import "NSStringAdditions.h"
#import "CategoryMatcher.h"
#import "ParsedDataFields.h"
#import "NSMutableArrayAdditions.h"
#import "AdListResultsProcessor.h"
#import "AdListResultsProcessor_Protected.h"

#import "DataMap.h"

NSString* const FIELD_TITLE = @"title";
NSString* const FIELD_AD = @"ad";
NSString* const FIELD_NEXT = @"linkNext";
NSString* const FIELD_SQFT = @"minSqft";
NSString* const FIELD_SUBLOCATION_ABBR_SEL = @"sublocationAbbrSel";
NSString* const FIELD_SUBLOCATION_NAME_SEL = @"sublocationNameSel";
NSString* const FIELD_SUBLOCATION_ABBR = @"sublocationAbbr";
NSString* const FIELD_SUBLOCATION_NAME = @"sublocationName";
NSString* const FIELD_NEIGHBORHOODS_VALUE = @"neighborhoodsValue";
NSString* const FIELD_NEIGHBORHOODS_KEYNAME = @"neighborhoodsKeyName";

@implementation AdListResultsProcessor

- (NSObject*) parseResultArray:(NSArray*)resultArray {
    //NSLog(@"RESULT %@", resultArray);
    
    NSMutableArray* groupNames = [NSMutableArray array];
    NSMutableArray* groups = [NSMutableArray array];
    NSMutableArray* group = nil;
    NSString* next100 = nil;
    NSNumber* sqft = [NSNumber numberWithBool:NO];
    
    NSMutableArray* abreviationsSel = [NSMutableArray array];
    NSMutableArray* sublocationNamesSel = [NSMutableArray array];
    NSMutableArray* abreviationsOther = [NSMutableArray array];
    NSMutableArray* sublocationNamesOther = [NSMutableArray array];
    NSString* curSublocationAbbr;
    
    NSMutableArray* neighborhoodsValues = [NSMutableArray array];
	NSMutableArray* neighborhoodsKeyNames = [NSMutableArray array];
    NSString* neighborhoodsVal;
    NSString* neighborhoodsName;
    
    for (id item in resultArray)
    {
        NSString* fieldName = [item objectForKey:kFieldNameKey];
        if ([fieldName isEqualToString:FIELD_TITLE])
        {
            [groupNames s_addObject:[NSString stringWithString:[item objectForKey:kDataKey]]];
            group = [NSMutableArray array];
            [groups s_addObject:group];
        }
        else if ([fieldName isEqualToString:FIELD_AD])
        {
            AdData* ad = [self parseAdFromDictionary:[item objectForKey:kDataKey]];
            [group s_addObject:ad];
        }
        else if ([fieldName isEqualToString:FIELD_NEXT])
        {
            next100 = [self parseNextUrlFromDictionary:item];
        }
        else if ([fieldName isEqualToString:FIELD_SQFT])
        {
            sqft = [NSNumber numberWithBool:YES];
        }
        else if ([fieldName isEqualToString:FIELD_SUBLOCATION_ABBR_SEL])
        {
            curSublocationAbbr = [NSString stringWithString:[item objectForKey:kDataKey]];
        }
        else if ([fieldName isEqualToString:FIELD_SUBLOCATION_NAME_SEL])
        {
            [abreviationsSel s_addObject:curSublocationAbbr];
            [sublocationNamesSel s_addObject:[item objectForKey:kDataKey]];
        }
        else if ([fieldName isEqualToString:FIELD_SUBLOCATION_ABBR])
        {
            curSublocationAbbr = [NSString stringWithString:[item objectForKey:kDataKey]];
        }
        else if ([fieldName isEqualToString:FIELD_SUBLOCATION_NAME])
        {
            [abreviationsOther s_addObject:curSublocationAbbr];
            [sublocationNamesOther s_addObject:[item objectForKey:kDataKey]];
        }
        else if ([fieldName isEqualToString:FIELD_NEIGHBORHOODS_VALUE])
        {
            neighborhoodsVal = [NSString stringWithString:[item objectForKey:kDataKey]];
        }
        else if ([fieldName isEqualToString:FIELD_NEIGHBORHOODS_KEYNAME])
        {
            neighborhoodsName = [item objectForKey:kDataKey];
            if (IsStringWithAnyText(neighborhoodsVal) && IsStringWithAnyText(neighborhoodsName)) {
                [neighborhoodsValues s_addObject:neighborhoodsVal];
                [neighborhoodsKeyNames s_addObject:neighborhoodsName];
            }
        }
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:groupNames,KEY_GROUP_NAMES,
			groups,KEY_GROUPS,
			(nil!=next100 ? (id)next100:(id)[NSNull null]), KEY_NEXT_URL,
            ([neighborhoodsValues count]>0) ? [[[NSDictionary alloc] initWithObjects:neighborhoodsValues forKeys:neighborhoodsKeyNames] autorelease] :
                                             [NSNull null], KEY_NEIGHBORHOODS,
			sqft, KEY_SQFT,
            [self parseSublocationsFromAbbrs:abreviationsSel andNames:sublocationNamesSel
                                   andOtherAbbrs:abreviationsOther andOtherNames:sublocationNamesOther], KEY_SUBLOCATIONS, nil];

}

- (AdData*)parseAdFromDictionary:(NSDictionary*)adDict {
    
    AdData* adData = [[[AdData alloc] init] autorelease];
    
    adData.link = [adDict objectForKey:FIELD_AD_LINK]; 
    adData.title =[adDict objectForKey:FIELD_AD_TITLE]; 
    adData.price =[adDict objectForKey:FIELD_AD_PRICE]; 
    adData.place =[adDict objectForKey:FIELD_AD_LOCATION];
    
    NSString* thumb_src =[adDict objectForKey:FIELD_AD_THUMBNAIL];
    if (IsStringWithAnyText(thumb_src)) {
        thumb_src = [NSString stringWithFormat:CRAIGSLIST_MEDIUM_THUMBNAIL_FORMAT,thumb_src];
    }
    adData.thumbnailLink = thumb_src;
    
    return adData;
}

- (NSString*)parseNextUrlFromDictionary:(NSDictionary*)dict {
    NSString* next100 = [dict objectForKey:kDataKey];
    
    if (nil!=next100) {
		NSString* url = [[self URL] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		NSRange rangeOfIndex = [url rangeOfString:@"index[0-9]*\\.html$" options:NSRegularExpressionSearch];
		if (NSNotFound != rangeOfIndex.location) {
			next100 = [url stringByReplacingCharactersInRange:rangeOfIndex withString:next100];
		} else {
			next100 = [url stringByAppendingURLComponent:next100];
		}
	}
    
    return next100;
}

- (NSDictionary*)parseSublocationsFromAbbrs:(NSArray*)abbrs andNames:(NSArray*)names andOtherAbbrs:(NSArray*)otherAbbrs andOtherNames:(NSArray*)otherNames {
    
    NSMutableArray* abreviations = [NSMutableArray array];
    NSMutableArray* sublocationNames = [NSMutableArray array];
    
    unsigned long abbrsCount;
    BOOL passFirst = NO;
    unsigned long i;
    NSString* abbr;
    
    //selected sublocations
    abbrsCount = [abbrs count];
    for(i = 0; i < abbrsCount; i++)
    {
        abbr = [abbrs objectAtIndex:i];
        if (IsStringWithAnyText(abbr)) {
            NSString* subName = [names objectAtIndex:i];
            
            if([CategoryMatcher abreviationIsTopCategory:abbr])
            {
                break;
            }
            else if(IsStringWithAnyText(abbr) && IsStringWithAnyText(subName) ){
                [abreviations s_addObject:abbr];
                [sublocationNames s_addObject:subName];
                passFirst = YES;
                break;
            }
        }
    }
    
    //other sublocations
    abbrsCount = [otherAbbrs count];
    for(i = 0; i < abbrsCount; i++)
    {
        abbr = [otherAbbrs objectAtIndex:i];
        NSString* subName = [otherNames objectAtIndex:i];
        if(IsStringWithAnyText(abbr) && IsStringWithAnyText(subName) && !passFirst && ![CategoryMatcher abreviationIsTopCategory:abbr]){
            //[abreviations s_addObject:[abbr isEqualToString:@"search"] ? [otherAbbrs objectAtIndex:i]: abbr];
            [abreviations s_addObject:abbr];
            [sublocationNames s_addObject:subName];
        }
        passFirst = NO;
    }
    
    return [[[NSDictionary alloc] initWithObjects:sublocationNames forKeys:abreviations] autorelease];
}

@end
