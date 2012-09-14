//
//  SAXAdListParserTest.m
//  saxcraig
//
//  Created by Vadim A. Khohlov on 9/12/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "Defs.h"
#import "SAXAdListParserTest.h"
#import "UnitTestHelper.h"
#import "SAXAdListParser.h"
#import "ParsedAdListTitle.h"
#import "ParsedAdData.h"

@implementation SAXAdListParserTest

- (void) testSimpleAdList {
    
    NSString* htmlString = [self.unitTestHelper contentsOfFile:@"SimpleAdList"];
    
    SAXAdListParser* parser = [[SAXAdListParser alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding ] encoding:NSUTF8StringEncoding];
    
    NSDictionary* adsDict = (NSDictionary*)[parser parse];
	
    ParsedAdListTitle* listTitle = (ParsedAdListTitle *)[adsDict objectForKey:KEY_ADS_LIST_TITLE];
    STAssertEqualObjects(listTitle.title, @"Tue Sep 11", @"Wrong title %@", listTitle.title);

    NSArray* ads = [adsDict objectForKey:KEY_ADS_LIST];
    STAssertTrue(2 == [ads count], @"Expected 2 ads but received %lu", [ads count]);
    
    ParsedAdData* adData = [ads objectAtIndex:0];
    STAssertEqualObjects(adData.title, @"THE PLAYMATE BOOK", @"Wrong title %@", adData.title);
    STAssertEqualObjects(adData.link, @"http://losangeles.craigslist.org/sfv/bks/3253676408.html", @"Wrong link %@", adData.link);
    STAssertEqualObjects(adData.price, @"$30", @"Wrong price %@", adData.price);
    STAssertEqualObjects(adData.location, @"Studio City", @"Wrong location %@", adData.location);
        
    adData = [ads objectAtIndex:1];
    STAssertEqualObjects(adData.title, @"BOOKS-BOOKS-BOOKS-BOOKS", @"Wrong title %@", adData.title);
    STAssertEqualObjects(adData.link, @"http://losangeles.craigslist.org/wst/bks/3229115844.html", @"Wrong link %@", adData.link);
    STAssertEqualObjects(adData.price, @"", @"Wrong price %@", adData.price);
    STAssertEqualObjects(adData.location, @"WEST LOS ANGELES", @"Wrong location %@", adData.location);
    
    [parser release];
   
}

- (void) testBooksAndMagAd {
    NSString* htmlString = [self.unitTestHelper contentsOfFile:@"BooksAndMagAd"];
    
    SAXAdListParser* parser = [[SAXAdListParser alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding ] encoding:NSUTF8StringEncoding];
    
    NSDictionary* adsDict = (NSDictionary*)[parser parse];
	
    NSArray* ads = [adsDict objectForKey:KEY_ADS_LIST];
    //Just check that file was processed entirely.
    //correctens of parsing is checked in a previous test
    STAssertTrue(100 == [ads count], @"Expected 100 ads but received %lu", [ads count]);
    
    [parser release];
}

@end
