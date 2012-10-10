//
//  AdListResultsProcessor_Protected.h
//  saxcraig
//
//  Created by Vadim Khohlov on 10/9/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

extern NSString* const FIELD_AD;
extern NSString* const FIELD_AD_UNPARSED;
extern NSString* const FIELD_NEXT;
extern NSString* const FIELD_SQFT;
extern NSString* const FIELD_NEIGHBORHOODS_VALUE;
extern NSString* const FIELD_NEIGHBORHOODS_KEYNAME;
extern NSString* const FIELD_SUBLOCATION_ABBR_SEL;
extern NSString* const FIELD_SUBLOCATION_NAME_SEL;
extern NSString* const FIELD_SUBLOCATION_ABBR;
extern NSString* const FIELD_SUBLOCATION_NAME;

#import "AdListResultsProcessor.h"

@class  AdData;

@interface AdListResultsProcessor (Protected)

- (AdData*)parseAdFromDictionary:(NSDictionary*)adDict;

/**
 Parses sublocations
 @param abbrs selected abbreviations of sublocations
 @param names selected names of subloactions
 @param otherAbbrs other abbreviations of sublocations
 @param otherNames other names
 @return NSDictionary {abbr = name}
 */
- (NSDictionary*)parseSublocationsFromAbbrs:(NSArray*)abbrs andNames:(NSArray*)names andOtherAbbrs:(NSArray*)otherAbbrs andOtherNames:(NSArray*)otherNames;

@end
