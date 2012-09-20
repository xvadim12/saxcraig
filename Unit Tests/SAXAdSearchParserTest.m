//
//  SAXAdSearchParserTest.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/17/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "Defs.h"
#import "UnitTestHelper.h"
#import "SAXAdSearchParser.h"
#import "ParsedAdData.h"

#import "SAXAdSearchParserTest.h"

@implementation SAXAdSearchParserTest

- (void) testSimpleAdSearch {
    
    NSString* htmlString = [self.unitTestHelper contentsOfFile:@"SimpleBookSearch"];
    
    SAXAdSearchParser* parser = [[SAXAdSearchParser alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding ] encoding:NSUTF8StringEncoding];
    NSArray* ads = (NSArray*)[parser parse];
    
    STAssertTrue(2 == [ads count], @"Expected 2 ads but received %lu", [ads count]);
    
    ParsedAdData* adData = [ads objectAtIndex:0];
    STAssertEqualObjects(adData.date, @"Sep 17", @"Wrong date %@", adData.date);
    STAssertEqualObjects(adData.title, @"high school textbook books for sale $5 to $10 - Updated List", @"Wrong title %@", adData.title);
    STAssertEqualObjects(adData.link, @"http://losangeles.craigslist.org/sgv/bks/3248680018.html", @"Wrong link %@", adData.link);
    STAssertEqualObjects(adData.price, @"$10", @"Wrong price %@", adData.price);
    STAssertEqualObjects(adData.location, @"pasadena area", @"Wrong location %@", adData.location);
    
    adData = [ads objectAtIndex:1];
    STAssertEqualObjects(adData.date, @"Sep 16", @"Wrong date %@", adData.date);
    STAssertEqualObjects(adData.title, @"Chapter 7 Bankruptcy by Nolo Press", @"Wrong title %@", adData.title);
    STAssertEqualObjects(adData.link, @"http://losangeles.craigslist.org/sfv/bks/3265772244.html", @"Wrong link %@", adData.link);
    STAssertEqualObjects(adData.price, @"$20", @"Wrong price %@", adData.price);
    STAssertEqualObjects(adData.location, @"Canoga Park", @"Wrong location %@", adData.location);
    
    [parser release];
    
}

- (void) testBookSearch {
    NSString* htmlString = [self.unitTestHelper contentsOfFile:@"BookSearch"];
    
    SAXAdSearchParser* parser = [[SAXAdSearchParser alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding ] encoding:NSUTF8StringEncoding];
    NSArray* ads = (NSArray*)[parser parse];
	
    //Just check that file was processed entirely.
    //correctens of parsing is checked in a previous test
    STAssertTrue(100 == [ads count], @"Expected 100 ads but received %lu", [ads count]);
    
    [parser release];
}

@end
