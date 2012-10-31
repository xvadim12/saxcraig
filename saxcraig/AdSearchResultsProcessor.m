//
//  PSAXAdSearchParser.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/1/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "Defs.h"
#import "GlobalFunctions.h"
#import "Translate.h"
#import "NSStringAdditions.h"
#import "AdData.h"
#import "AdListResultsProcessor_Protected.h"
#import "AdSearchResultsProcessor.h"
#import "ParsedDataFields.h"
#import "NSMutableArrayAdditions.h"

#import "DataMap.h"

NSString* const FIELD_LIST_TITLE = @"listTitle";
NSString* const FIELD_LIST_TITLE_FULL = @"listTitleFull";
NSString* const FIELD_LIST_TITLE_FOUND = @"listTitleFound";
NSString* const FIELD_LIST_TITLE_DISPLAYING = @"listTitleDisplaying";

@implementation AdSearchResultsProcessor

- (NSObject*) parseResultArray:(NSArray*)resultArray {
    //NSLog(@"RESULT %@", resultArray);
    
    BOOL isFirstTitleFound = NO;
    NSString* listTitleFound = nil;
    NSString* listTitleDisplaying = nil;
    
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
        if ([fieldName isEqualToString:FIELD_LIST_TITLE_FOUND])
            listTitleFound = [item objectForKey:kDataKey];
        else if ([fieldName isEqualToString:FIELD_LIST_TITLE_DISPLAYING]) {
            listTitleDisplaying = [item objectForKey:kDataKey];
        }
        else if (([fieldName isEqualToString:FIELD_LIST_TITLE] && nil != listTitleDisplaying) ||
                 ([fieldName isEqualToString:FIELD_LIST_TITLE_FULL] && !isFirstTitleFound))
        {
            isFirstTitleFound = YES;
            [groupNames s_addObject:[self buildGroupNameFromDisplaying:listTitleDisplaying found:listTitleFound andDefault:[item objectForKey:kDataKey]]];
            group = [NSMutableArray array];
            [groups s_addObject:group];
            listTitleDisplaying = nil;
            listTitleFound = nil;
            
        }
        else if ([fieldName isEqualToString:FIELD_NEXT] && nil == next100)   //parse only first 'next url'
        {
            next100 = [item objectForKey:kDataKey];
        }
        else if ([fieldName isEqualToString:FIELD_AD])
        {
            AdData* ad = [self parseAdFromDictionary:[item objectForKey:kDataKey]];
            [group s_addObject:ad];
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
    
    //Remove last group name as it duplicates the first one
    [groupNames removeLastObject];
    [groups removeLastObject];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:groupNames,KEY_GROUP_NAMES,
			groups,KEY_GROUPS,
			(nil!=next100 ? (id)next100:(id)[NSNull null]), KEY_NEXT_URL,
            ([neighborhoodsValues count]>0) ? [[[NSDictionary alloc] initWithObjects:neighborhoodsValues forKeys:neighborhoodsKeyNames] autorelease] :
                    [NSNull null], KEY_NEIGHBORHOODS,
			sqft, KEY_SQFT,
            [self parseSublocationsFromAbbrs:abreviationsSel andNames:sublocationNamesSel
                               andOtherAbbrs:abreviationsOther andOtherNames:sublocationNamesOther], KEY_SUBLOCATIONS,
            nil];
}

- (NSString*)buildGroupNameFromDisplaying:(NSString*) displaying found:(NSString*)found andDefault:(NSString*) defaultName {
    return nil != displaying ?
        [NSString stringWithFormat:@"%@ %@ %@ %@",T_LISTINGS, displaying,T_OUT_OF,found] :
        defaultName;
}

NSString* const FIELD_AD_SEPARATOR = @"separator";

- (AdData*)parseAdFromDictionary:(NSDictionary*)adDict {
    
    AdData* adData = [super parseAdFromDictionary:adDict];
    
    NSString* adDate = [adDict objectForKey:FIELD_AD_DATE]; 
    NSString* separator = [adDict objectForKey:FIELD_AD_SEPARATOR];
    separator = nil != separator ? [NSString stringWithFormat:@"%@ ", separator] : @"";
    adData.title = [NSString stringWithFormat:@"%@ %@%@", adDate, separator, adData.title];
    return adData;
}

@end
