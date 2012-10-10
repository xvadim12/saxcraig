//
//  ParametrizedSAXParser.h
//  saxcraig
//
//  Created by Vadim Khohlov on 9/19/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DTHTMLParser.h"

//Keys in result subdictionaries
extern NSString* const kDataKey;
extern NSString* const kFieldNameKey;

@interface ParametrizedSAXParser : NSObject <DTHTMLParserDelegate>

/**
 Inits parser with data map
 
 The data map structure:
 {
    path_to_item: {
                    fieldName: @"...",
                    source: @"...", - data or attribute value
                    trimmedChars: @"..." - prefix and suffix chars which should be trimmed
                  }
 }
 */
- (id) initWithDataMap:(NSString*)stringDataMap;

/**
 Performs parsing.
 @return NSArray of data
 */
- (NSArray*) parse:(NSString*)htmlString;

@end
