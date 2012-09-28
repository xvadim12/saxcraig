//
//  AdListPSAXParser.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/28/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "Defs.h"
#import "URLDefs.h"
#import "AdData.h"
#import "NSStringAdditions.h"

#import "PSAXAdListParser.h"

NSString* const FIELD_TITLE = @"title";
NSString* const FIELD_AD = @"ad";
NSString* const FIELD_NEXT = @"linkNext";
NSString* const FIELD_SQFT = @"minSqft";

@interface PSAXAdListParser ()

- (AdData*)parseAdFromDictionary:(NSDictionary*)adDict;
- (NSString*)parseNextUrlFromDictionary:(NSDictionary*)dict;
@end

@implementation PSAXAdListParser

- (NSObject*) parseResultArray:(NSArray*)resultArray {
    //NSLog(@"RESULT %@", resultArray);
    
    NSMutableArray* groupNames = [NSMutableArray array];
    NSMutableArray* groups = [NSMutableArray array];
    NSMutableArray* group = nil;
    NSString* next100 = nil;
    NSNumber* sqft = [NSNumber numberWithBool:NO];
    
    for (id item in resultArray)
    {
        NSString* fieldName = [item objectForKey:kFieldNameKey];
        if ([fieldName isEqualToString:FIELD_TITLE])
        {
            [groupNames addObject:[NSString stringWithString:[item objectForKey:kDataKey]]];
            group = [NSMutableArray array];
            [groups addObject:group];
        }
        else if ([fieldName isEqualToString:FIELD_AD])
        {
            AdData* ad = [self parseAdFromDictionary:[item objectForKey:kDataKey]];
            [group addObject:ad];
            [ad release];
        }
        else if ([fieldName isEqualToString:FIELD_NEXT])
            next100 = [self parseNextUrlFromDictionary:item];
        else if ([fieldName isEqualToString:FIELD_SQFT])
            sqft = [NSNumber numberWithBool:YES];
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:groupNames,KEY_GROUP_NAMES,
			groups,KEY_GROUPS,
			(nil!=next100 ? (id)next100:(id)[NSNull null]), KEY_NEXT_URL,
			//[self parseNeighborhoods:htmlString], KEY_NEIGHBORHOODS,
			sqft, KEY_SQFT,
            //[self parseSublocations:htmlString], KEY_SUBLOCATIONS,
			nil];

}

NSString* const FIELD_AD_LINK = @"link";
NSString* const FIELD_AD_TITLE = @"title";
NSString* const FIELD_AD_LOCATION = @"location";
NSString* const FIELD_AD_PRICE = @"price";
NSString* const FIELD_AD_THUMBNAIL = @"thumbnail";
NSString* const THUMBNAIL_PREFIX = @"images:";
int const THUMBNAIL_PREFIX_LEN = 7;

- (AdData*)parseAdFromDictionary:(NSDictionary*)adDict {
    AdData* adData = [[AdData alloc] init];
    adData.link = [adDict objectForKey:FIELD_AD_LINK];
    adData.title = [adDict objectForKey:FIELD_AD_TITLE];
    adData.price = [adDict objectForKey:FIELD_AD_PRICE];
    adData.place = [adDict objectForKey:FIELD_AD_LOCATION];
    
    NSString* thumb_src = [adDict objectForKey:FIELD_AD_THUMBNAIL];
    if ([thumb_src hasPrefix:THUMBNAIL_PREFIX])
        thumb_src = [thumb_src substringFromIndex:THUMBNAIL_PREFIX_LEN];
    if (nil!=thumb_src) {
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

@end
