//
//  ParametrizedSAXParser.h
//  saxcraig
//
//  Created by Vadim Khohlov on 9/19/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DTHTMLParser.h"

@interface ParametrizedSAXParser : NSObject <DTHTMLParserDelegate>

/**
 Inits parser with data, encoding and data map
 
 The data map structure:
 {
    path_to_item: {
                    fieldName: @"...",
                    source: @"...", - data or attribute value
                    trimmedChars: @"..." - prefix and suffix chars which should be trimmed
                  }
 }
 */
- (id)initWithData:(NSData *)data encoding:(NSStringEncoding)encoding dataMap:(NSString*)dataMap;

/**
 Performs parsing.
 */
- (NSObject *) parse;

@end
