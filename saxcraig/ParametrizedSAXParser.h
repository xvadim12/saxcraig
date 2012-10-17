//
//  ParametrizedSAXParser.h
//  saxcraig
//
//  Created by Vadim Khohlov on 9/19/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataMapManager.h"
#import "DTHTMLParser.h"

@class DataMap;
@interface ParametrizedSAXParser : NSObject <DTHTMLParserDelegate>

@property (nonatomic, retain) DataMap* dataMap;

- (id) initWithType:(DataMapType)dataMapType;

/**
 Performs parsing.
 @return NSArray of data
 */
- (NSArray*) parse:(NSString*)htmlString;

/**
 Performs parsing of html string with using of data map with given type
 @return corresponding CraigList object
 */
- (NSObject*) parseHtmlString:(NSString*)htmlString;

@end
