//
//  SAXParser.m
//  saxcraig
//
//  Created by Vadim A. Khohlov on 9/12/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "SAXParser.h"

@implementation SAXParser {
    
    DTHTMLParser* _htmlParser;
}

@synthesize parserState;
@synthesize prevParserState;
@synthesize unusedStateCount;

- (id) initWithData:(NSData *)data encoding:(NSStringEncoding)encoding {
    if (self = [super init]) {
        _htmlParser = [[DTHTMLParser alloc] initWithData:data encoding:encoding];
        _htmlParser.delegate = self;
    }
    return self;
}

- (void) dealloc {
    [_htmlParser release];
	_htmlParser = nil;
	[super dealloc];
}

- (void)prepareParsing {
    parserState = PARSER_STATE_INIT;
    prevParserState = PARSER_STATE_INIT;
}

- (NSObject*)buildResult {
    return [NSNull null];
}

- (NSObject*) parse {
    [self prepareParsing];
    [_htmlParser parse];
    return [self buildResult];
}
@end

