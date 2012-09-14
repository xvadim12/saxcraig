//
//  SAXAdListParser.m
//  saxcraig
//
//  Created by Vadim A. Khohlov on 9/12/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "Defs.h"
#import "SAXAdListParser.h"
#import "ParsedAdData.h"
#import "ParsedAdListTitle.h"

#define PARSER_STATE_TITLE 1
#define PARSER_STATE_AD 2
#define PARSER_STATE_AD_TITLE 3
#define PARSER_STATE_AD_PRICE 4
#define PARSER_STATE_AD_LOCATION 5
#define PARSER_STATE_AD_UNUSED 6

#define CLASS_ATTR @"class"
// Ad list tag and value for class attribute - may be we should specify this via some config?
#define TITLE_TAG @"h4"
#define TITLE_TAG_CLASS @"ban"

#define AD_TAG @"p"
#define AD_TAG_CLASS @"row"
#define AD_TITLE_TAG @"a"
#define AD_PRICE_TAG @"span"
#define AD_PRICE_TAG_CLASS @"itempp"
#define AD_LOCATION_TAG @"span"
#define AD_LOCATION_TAG_CLASS @"itempn"

@interface SAXAdListParser ()

@property (nonatomic, retain) NSMutableString *listTitle;

@property (nonatomic, retain) NSMutableString *adTitle;
@property (nonatomic, retain) NSMutableString *adLink;
@property (nonatomic, retain) NSMutableString *adPrice;
@property (nonatomic, retain) NSMutableString *adLocation;

@property (nonatomic, retain) NSMutableArray *ads;

@end


@implementation SAXAdListParser

@synthesize listTitle;
@synthesize adTitle;
@synthesize adLink;
@synthesize adPrice;
@synthesize adLocation;
@synthesize ads;

- (void) dealloc {
	self.listTitle = nil;
    self.adTitle = nil;
    self.adLink = nil;
    self.adPrice = nil;
    self.adLocation = nil;
    self.ads = nil;
    
	[super dealloc];
}

- (id) initWithData:(NSData *)data encoding:(NSStringEncoding)encoding {
    if (self = [super initWithData:data encoding:encoding]) {
        self.listTitle = [[NSMutableString alloc] init];
        
        self.adTitle = [[NSMutableString alloc] init];
        self.adLink = [[NSMutableString alloc] init];
        self.adPrice = [[NSMutableString alloc] init];
        self.adLocation = [[NSMutableString alloc] init];
        
        self.ads = [NSMutableArray array];  //arrayWithCapacity: 100 ??
    }
    return self;
}

- (NSObject*)buildResult {
    
    ParsedAdListTitle *parsedListTitle = [[ParsedAdListTitle alloc] init];
    parsedListTitle.title = [listTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    
    NSDictionary *resDict = [NSDictionary dictionaryWithObjectsAndKeys:ads, KEY_ADS_LIST,
                                                                       parsedListTitle, KEY_ADS_LIST_TITLE, nil];
    [parsedListTitle release];
    
    return resDict;
}

- (void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    NSString *elementClass = [attributeDict valueForKey:@"class"];
    
    if ([elementName isEqualToString:TITLE_TAG] && [elementClass isEqualToString:TITLE_TAG_CLASS]) {
        self.parserState = PARSER_STATE_TITLE;
        [listTitle setString:@""];
    }
    else if ([elementName isEqualToString:AD_TAG] && [elementClass isEqualToString:AD_TAG_CLASS])
    {
        self.parserState = PARSER_STATE_AD;
        self.prevParserState = PARSER_STATE_AD;
        self.unusedStateCount = 0;
    }
    else if (self.parserState == PARSER_STATE_AD)
    {
        if ([elementName isEqualToString:AD_TITLE_TAG]) {
            self.parserState = PARSER_STATE_AD_TITLE;
            [self.adLink setString:[attributeDict valueForKey:@"href"]];
            [self.adTitle setString:@""];
        }
        else if ([elementName isEqualToString:AD_PRICE_TAG] && [elementClass isEqualToString:AD_PRICE_TAG_CLASS]) {
            self.parserState = PARSER_STATE_AD_PRICE;
            [self.adPrice setString:@""];
        }
        else if ([elementName isEqualToString:AD_LOCATION_TAG] && [elementClass isEqualToString:AD_LOCATION_TAG_CLASS]) {
            self.parserState = PARSER_STATE_AD_LOCATION;
            [self.adLocation setString:@""];
        } else {
            self.parserState = PARSER_STATE_AD_UNUSED;
            self.unusedStateCount++;
        }
    }
    else if (self.parserState == PARSER_STATE_AD_UNUSED)
        self.unusedStateCount++;
}

- (void)parser:(DTHTMLParser *)parser foundCharacters:(NSString *)string {
    
    if (self.parserState < PARSER_STATE_TITLE)
        return;
    
    int checkedState = (self.parserState == PARSER_STATE_AD_UNUSED) ? self.prevParserState : self.parserState;
    if (checkedState == PARSER_STATE_TITLE)
        [self.listTitle appendString:string];
    else if (checkedState == PARSER_STATE_AD_TITLE) {
        [self.adTitle appendString:string];
    }
    else if (checkedState == PARSER_STATE_AD_PRICE) {
        [self.adPrice appendString:string];
    }
    else if (checkedState == PARSER_STATE_AD_LOCATION) {
        [self.adLocation appendString:string];
    }
}

- (void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    if (self.parserState == PARSER_STATE_AD_UNUSED) {
        self.unusedStateCount--;
        if (0 == self.unusedStateCount) {
            self.parserState = self.prevParserState;
        }
    }
    else if (self.parserState == PARSER_STATE_AD && [elementName isEqualToString:AD_TAG])
    {
        ParsedAdData* adData = [[ParsedAdData alloc] init];
        adData.link = [self.adLink stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        adData.title = [self.adTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        adData.price = [self.adPrice stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        adData.location = [self.adLocation stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ()-\n\t\r"]];
        [self.ads addObject:adData];
        [adData release];
        
        self.parserState = PARSER_STATE_INIT;
    } else if (self.parserState > PARSER_STATE_AD)
        self.parserState = PARSER_STATE_AD;
    else if (self.parserState == PARSER_STATE_TITLE && [elementName isEqualToString:TITLE_TAG])
        self.parserState = PARSER_STATE_INIT;
}

@end

