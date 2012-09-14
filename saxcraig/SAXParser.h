//
//  SAXParser.h
//  saxcraig
//
//  Created by Vadim A. Khohlov on 9/12/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "DTHTMLParser.h"

#define PARSER_STATE_INIT 0

/**
 Base class for HTML-parsing with DTHTMLParser. Doesn't perform parsing itself. Just contains common methods.
 Derived classes should implement DTHTMLParserDelegate-protocol for real parsing.
 */
@interface SAXParser : NSObject <DTHTMLParserDelegate>

@property (assign, nonatomic) int parserState;
@property (assign, nonatomic) int prevParserState;
@property (assign, nonatomic) int unusedStateCount;


/**
 Inits parser with data and encoding
 */
- (id)initWithData:(NSData *)data encoding:(NSStringEncoding)encoding;

/**
 Performs parsing.
 */
- (NSObject *) parse;

/**
 This method called before parsing
 */
- (void)prepareParsing;

/**
 This method called after parsing. It's result is used as result of parsing.
 */
- (NSObject*)buildResult;

@end
