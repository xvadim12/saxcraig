//
//  SAXAdSearchParser.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/18/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "SAXAdSearchParser.h"
#import "ParsedAdData.h"

#define PARSER_STATE_AD 1
#define PARSER_STATE_AD_DATE 2
#define PARSER_STATE_AD_TITLE 3
#define PARSER_STATE_AD_PRICE 4
#define PARSER_STATE_AD_LOCATION 5
#define PARSER_STATE_AD_UNUSED 6

#define CLASS_ATTR @"class"

#define AD_TAG @"p"
#define AD_TAG_CLASS @"row"
#define AD_DATE_TAG @"span"
#define AD_DATE_TAG_CLASS @"itemdate"
#define AD_TITLE_TAG @"a"
#define AD_PRICE_TAG @"span"
#define AD_PRICE_TAG_CLASS @"itempp"
#define AD_LOCATION_TAG @"span"
#define AD_LOCATION_TAG_CLASS @"itempn"

/*
 Parser of serach results of ads: http://losangeles.craigslist.org/search/bka?query=book&srchType=A&minAsk=&maxAsk= :
 
 <body ..>
 ...
 <p class="row" data-latitude="" data-longitude="">
    <span class="ih" id="images:5T55R65M63Eb3G23Nac93e1407608cff714f4.jpg">&nbsp;</span>
    <span class="itemdate"> Sep 17</span>
    <span class="itemsep"> - </span>
    <a href="http://losangeles.craigslist.org/sgv/bks/3248680018.html">high school textbook books for sale $5 to $10 - Updated List</a>
    <span class="itemsep"> - </span>
    <span class="itemph"></span>
    <span class="itempp"> $10</span>
    <span class="itempn"><font size="-1"> (pasadena area)</font></span>
    <span class="itemcg" title="bks"> <small class="gc"><a href="/bks/">books & magazines - by owner</a></small></span>
    <span class="itempx"> <span class="p"> pic</span></span>
    <br class="c">
 </p>

 </body>
 
 See also comments for SAXAdListParser.
 */

@interface SAXAdSearchParser ()

@property (nonatomic, retain) NSMutableString *adDate;
@property (nonatomic, retain) NSMutableString *adTitle;
@property (nonatomic, retain) NSMutableString *adLink;
@property (nonatomic, retain) NSMutableString *adPrice;
@property (nonatomic, retain) NSMutableString *adLocation;

@property (nonatomic, retain) NSMutableArray *ads;

@end

@implementation SAXAdSearchParser

@synthesize adDate;
@synthesize adTitle;
@synthesize adLink;
@synthesize adPrice;
@synthesize adLocation;
@synthesize ads;

- (void) dealloc {
	self.adDate = nil;
    self.adTitle = nil;
    self.adLink = nil;
    self.adPrice = nil;
    self.adLocation = nil;
    self.ads = nil;
    
	[super dealloc];
}

- (id) initWithData:(NSData *)data encoding:(NSStringEncoding)encoding {
    if (self = [super initWithData:data encoding:encoding]) {
        self.adDate = [[NSMutableString alloc] init];
        self.adTitle = [[NSMutableString alloc] init];
        self.adLink = [[NSMutableString alloc] init];
        self.adPrice = [[NSMutableString alloc] init];
        self.adLocation = [[NSMutableString alloc] init];
        
        self.ads = [NSMutableArray array];
    }
    return self;
}

- (NSObject*)buildResult {
    
    return [NSArray arrayWithArray:self.ads];
}

- (void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    NSString *elementClass = [attributeDict valueForKey:CLASS_ATTR];
    
    if ([elementName isEqualToString:AD_TAG] && [elementClass isEqualToString:AD_TAG_CLASS])
    {
        self.parserState = PARSER_STATE_AD;
        self.prevParserState = PARSER_STATE_AD;
        self.unusedStateCount = 0;
    }
    else if (self.parserState == PARSER_STATE_AD)
    {
        if ([elementName isEqualToString:AD_DATE_TAG] && [elementClass isEqualToString:AD_DATE_TAG_CLASS]) {
            self.parserState = PARSER_STATE_AD_DATE;
            [self.adDate setString:@""];
        }
        else if ([elementName isEqualToString:AD_TITLE_TAG]) {
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
    
    if (self.parserState < PARSER_STATE_AD)
        return;
    
    int checkedState = (self.parserState == PARSER_STATE_AD_UNUSED) ? self.prevParserState : self.parserState;
    
    if (checkedState == PARSER_STATE_AD_DATE) {
        [self.adDate appendString:string];
    }
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
        adData.date = [self.adDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        adData.title = [self.adTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        adData.price = [self.adPrice stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        adData.location = [self.adLocation stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ()-\n\t\r"]];
        [self.ads addObject:adData];
        [adData release];
        
        self.parserState = PARSER_STATE_INIT;
    } else if (self.parserState > PARSER_STATE_AD)
        self.parserState = PARSER_STATE_AD;
}

@end
