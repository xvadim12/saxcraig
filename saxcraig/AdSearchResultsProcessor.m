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
#import "CategoryMatcher.h"
#import "ParsingHelper.h"
#import "AdListResultsProcessor_Protected.h"
#import "AdSearchResultsProcessor.h"
#import "ParsedDataFields.h"
#import "NSMutableArrayAdditions.h"

#import "ParametrizedSAXParser.h"

NSString* const FIELD_LIST_TITLE = @"listTitle";
NSString* const FIELD_LIST_TITLE_FULL = @"listTitleFull";

NSString* const SUB_TITLE_FOUND = @"Found: ";
NSString* const SUB_TITLE_DISPLAING = @"Displaying: ";

@interface AdSearchResultsProcessor ()

-(NSString*)parseGroupNameFromString:(NSString*)listTitle;

@end

@implementation AdSearchResultsProcessor {
    
    CategoryMatcher* _matcher;
    ParsingHelper* _parsingHelper;
}

- (NSObject*) parseResultArray:(NSArray*)resultArray {
    //NSLog(@"RESULT %@", resultArray);
    
    BOOL isFirstTitleFound = NO;
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
    
    _matcher = [[CategoryMatcher alloc] initWithHref:[self.requestInfo objectForKey:KEY_TOP_CATEGORY_HREF]];
    _parsingHelper = [[ParsingHelper alloc] init];
    
    for (id item in resultArray)
    {
        NSString* fieldName = [item objectForKey:kFieldNameKey];
        if ([fieldName isEqualToString:FIELD_LIST_TITLE])
        {
            //fist we try to extract group name from <h4> like 'Found: x Displaying 1-y'
            NSString* groupName = [NSString stringWithString:[item objectForKey:kDataKey]];
            NSRange foundRange = [groupName rangeOfString:SUB_TITLE_FOUND];
            if (NSNotFound != foundRange.location)
            {
                groupName = [self parseGroupNameFromString:groupName];
                if (nil != groupName)
                {
                    isFirstTitleFound = YES;
                    [groupNames s_addObject:groupName];
                    group = [NSMutableArray array];
                    [groups s_addObject:group];
                }
            }
        }if ([fieldName isEqualToString:FIELD_LIST_TITLE_FULL] && !isFirstTitleFound)
        {
            //if we did not find group name - extract it from full <h4> data
            NSString* groupName = [self parseGroupNameFromString:[item objectForKey:kDataKey]];
            if (nil != groupName)
            {
                isFirstTitleFound = YES;
                [groupNames s_addObject:groupName];
                group = [NSMutableArray array];
                [groups s_addObject:group];
            }
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
    
    [_matcher release];
    [_parsingHelper release];
    
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

- (NSDictionary*)parseSublocationsFromAbbrs:(NSArray*)abbrs andNames:(NSArray*)names andOtherAbbrs:(NSArray*)otherAbbrs andOtherNames:(NSArray*)otherNames {
    
    NSDictionary* searchSublocations = [super parseSublocationsFromAbbrs:abbrs andNames:names andOtherAbbrs:otherAbbrs andOtherNames:otherNames];
    
    NSMutableArray* abreviations = [NSMutableArray array];
    NSMutableArray* sublocationNames = [NSMutableArray array];
    
    for (NSString* key in [searchSublocations allKeys]){
        NSArray *parsedKey = [key componentsSeparatedByString:@"/"];
        NSRange queryRange = [[parsedKey lastObject] rangeOfString:@"?"];
        
        if (4==[parsedKey count] && NSNotFound!=queryRange.location) {
            [abreviations s_addObject:[[parsedKey lastObject] substringToIndex:queryRange.location]];
            [sublocationNames s_addObject:[searchSublocations objectForKey:key]];
            
        }  else if (1==[parsedKey count]) {
            [abreviations s_addObject:key];
            [sublocationNames s_addObject:[searchSublocations objectForKey:key]];
        }
    }
    
    return [[[NSDictionary alloc] initWithObjects:sublocationNames forKeys:abreviations] autorelease];
}

-(NSString*)parseGroupNameFromString:(NSString*)listTitle {
    
    NSString* groupName = nil;
    NSString* found = [listTitle substringBetweenFirst:SUB_TITLE_FOUND andSecond:@" "];
    found = [found stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSRange displaingRange = [listTitle rangeOfString:SUB_TITLE_DISPLAING];
    
    if (NSNotFound != displaingRange.location)
    {
        groupName = [listTitle substringFromIndex:(displaingRange.location + displaingRange.length)];
        groupName = [groupName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    if (nil!=groupName) {
        groupName = [NSString stringWithFormat:@"%@ %@ %@ %@",T_LISTINGS,groupName,T_OUT_OF,found];
    } else {
        //then let's take what we've got in h4 without the tags
        groupName = [NSString stringWithString:listTitle];
    }

    return groupName;
}

NSString* const FIELD_AD_SEPARATOR = @"separator";

- (AdData*)parseAdFromDictionary:(NSDictionary*)adDict {
    
    AdData* adData = [super parseAdFromDictionary:adDict];
    
    NSString* adDate = [adDict objectForKey:FIELD_AD_DATE]; 
    NSString* separator = [adDict objectForKey:FIELD_AD_SEPARATOR];
    separator = nil != separator ? [NSString stringWithFormat:@"%@ ", separator] : @"";
    NSString* title = [NSString stringWithFormat:@"%@ %@%@", adDate, separator, adData.title];
    if (nil == adData.price || 0 == [adData.price length])
    {
        adData.price = [_parsingHelper parseOutPriceForTitle:&title withMatcher:_matcher];
    }
    adData.title = title;
    
    return adData;
}

@end
