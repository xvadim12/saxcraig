//
//  ParametrizedSAXParserTest.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/19/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "UnitTestHelper.h"
#import "ParametrizedSAXParser.h"
#import "ParametrizedSAXParserTest.h"

@implementation ParametrizedSAXParserTest

- (void) testSimpleAdList {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adlist" withType:@"json"];
    NSString* htmlString = [self.unitTestHelper contentsOfFile:@"SimpleAdList"];

    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* ads =[parser parse:htmlString];
    
    //NSLog(@"ADS %@", ads);
    
    //5 items: one title, two ads, one next link, one next title
    STAssertTrue(5 == [ads count], @"Expected five items but found %lu", [ads count]);
    
    NSString *value;
    NSDictionary *data;
    NSDictionary *obj;
    
    //Title
    obj = [ads objectAtIndex: 0];
    STAssertEqualObjects(@"title", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"Tue Sep 11", [obj objectForKey: kDataKey], @"Wrong title %@", [obj objectForKey: kDataKey]);
    
    //Ads
    data = [ads objectAtIndex:1];
    STAssertEqualObjects(@"ad", [data objectForKey: kFieldNameKey], @"Wrong field name %@", [data objectForKey: kFieldNameKey]);
    obj = [data objectForKey:kDataKey];
    value = [obj valueForKey:@"title"];
    STAssertEqualObjects(value, @"THE PLAYMATE BOOK", @"Wrong title %@", value);
    value = [obj valueForKey:@"link"];
    STAssertEqualObjects(value, @"http://losangeles.craigslist.org/sfv/bks/3253676408.html", @"Wrong link %@", value);
    value = [obj valueForKey:@"price"];
    STAssertEqualObjects(value, @"$30", @"Wrong price %@", value);
    value = [obj valueForKey:@"location"];
    STAssertEqualObjects(value, @"Studio City", @"Wrong location %@", value);
    
    data = [ads objectAtIndex:2];
    STAssertEqualObjects(@"ad", [data objectForKey: kFieldNameKey], @"Wrong field name %@", [data objectForKey: kFieldNameKey]);
    obj = [data objectForKey:kDataKey];
    value = [obj valueForKey:@"title"];
    STAssertEqualObjects(value, @"BOOKS-BOOKS-BOOKS-BOOKS", @"Wrong title %@", value);
    value = [obj valueForKey:@"link"];
    STAssertEqualObjects(value, @"http://losangeles.craigslist.org/wst/bks/3229115844.html", @"Wrong link %@", value);
    value = [obj valueForKey:@"price"];
    STAssertEqualObjects(value, @"", @"Wrong price %@", value);
    value = [obj valueForKey:@"location"];
    STAssertEqualObjects(value, @"WEST LOS ANGELES", @"Wrong location %@", value);
    
    //Link to the next page
    obj = [ads objectAtIndex: 3];
    STAssertEqualObjects(@"linkNext", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"http://losangeles.craigslist.org/bka/index100.html", [obj objectForKey: kDataKey], @"Wrong link %@", [obj objectForKey: kDataKey]);
}

- (void) testManyCategoriesAdList {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adlist" withType:@"json"];
    NSString* htmlString = [self.unitTestHelper contentsOfFile:@"ManyCategories"];
    
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* ads =[parser parse:htmlString];

    STAssertTrue(108 == [ads count], @"Expected five items but found %lu", [ads count]);
    
}

- (void) testSimpleAdSearch {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adsearch" withType:@"json"];
    NSString* htmlString = [self.unitTestHelper contentsOfFile:@"SimpleBookSearch"];

    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* ads =[parser parse:htmlString];

    STAssertTrue(6 == [ads count], @"Expected count of items %lu", [ads count]);

    NSString *value;
    NSDictionary *data;
    NSDictionary *obj;
    
    //Ads
    data = [ads objectAtIndex:0];
    STAssertEqualObjects(@"ad", [data objectForKey: kFieldNameKey], @"Wrong field name %@", [data objectForKey: kFieldNameKey]);
    obj = [data objectForKey:kDataKey];
    value = [obj valueForKey:@"title"];
    STAssertEqualObjects(value, @"high school textbook books for sale $5 to $10 - Updated List", @"Wrong title %@", value);
    value = [obj valueForKey:@"link"];
    STAssertEqualObjects(value, @"http://losangeles.craigslist.org/sgv/bks/3248680018.html", @"Wrong link %@", value);
    value = [obj valueForKey:@"price"];
    STAssertEqualObjects(value, @"$10", @"Wrong price %@", value);
    value = [obj valueForKey:@"location"];
    STAssertEqualObjects(value, @"pasadena area", @"Wrong location %@", value);
    value = [obj valueForKey:@"date"];
    STAssertEqualObjects(value, @"Sep 17", @"Wrong date %@", value);
    
    data = [ads objectAtIndex:1];
    STAssertEqualObjects(@"ad", [data objectForKey: kFieldNameKey], @"Wrong field name %@", [data objectForKey: kFieldNameKey]);
    obj = [data objectForKey:kDataKey];
    value = [obj valueForKey:@"title"];
    STAssertEqualObjects(value, @"Chapter 7 Bankruptcy by Nolo Press", @"Wrong title %@", value);
    value = [obj valueForKey:@"link"];
    STAssertEqualObjects(value, @"http://losangeles.craigslist.org/sfv/bks/3265772244.html", @"Wrong link %@", value);
    value = [obj valueForKey:@"price"];
    STAssertEqualObjects(value, @"$20", @"Wrong price %@", value);
    value = [obj valueForKey:@"location"];
    STAssertEqualObjects(value, @"Canoga Park", @"Wrong location %@", value);
    value = [obj valueForKey:@"date"];
    STAssertEqualObjects(value, @"Sep 16", @"Wrong date %@", value);
    
    //Link to the next page
    obj = [ads objectAtIndex: 2];
    STAssertEqualObjects(@"linkNext", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"http://losangeles.craigslist.org/search/bka?query=book&srchType=A&s=100", [obj objectForKey: kDataKey],
                         @"Wrong link %@", [obj objectForKey: kDataKey]);
    
    //List title
    obj = [ads objectAtIndex: 3];
    STAssertEqualObjects(@"listTitle", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"Found: 1000 Displaying: 1 - 100", [obj objectForKey: kDataKey],
                         @"Wrong list title %@", [obj objectForKey: kDataKey]);
}

- (void) testAdWithoutImages {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"ad" withType:@"json"];
    NSString* htmlString = [self.unitTestHelper contentsOfFile:@"RusAdNoImages"];
    
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* ad =[parser parse:htmlString];

    //7 items: title, date, mailto,  location, body, posting id, unparsed
    STAssertTrue(7 == [ad count], @"Expected five items but found %lu", [ad count]);
    
    NSDictionary *obj;
    
    obj = [ad objectAtIndex: 0];
    STAssertEqualObjects(@"title", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"i-phone 5 совершенно - UAH100 (киев)", [obj objectForKey: kDataKey], @"Wrong title %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 3];
    STAssertEqualObjects(@"location", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"киев", [obj objectForKey: kDataKey], @"Wrong location %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 4];
    STAssertEqualObjects(@"body", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"i-phone 5 совершенно новый , количество практически неограничено .обращатесь!",
                         [obj objectForKey: kDataKey], @"Wrong body %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 5];
    STAssertEqualObjects(@"postingID", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"3292136338", [obj objectForKey: kDataKey], @"Wrong postinfID %@", [obj objectForKey: kDataKey]);
}

- (void) testAdImages1 {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"ad" withType:@"json"];
    NSString* htmlString = [self.unitTestHelper contentsOfFile:@"EnAdImages1"];
    
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* ad =[parser parse:htmlString];

    STAssertTrue(13 == [ad count], @"Expected five items but found %lu", [ad count]);
    
    NSDictionary *obj;
    
    obj = [ad objectAtIndex: 10];
    STAssertEqualObjects(@"body", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"BRAND NEW. \n\nCrispy pages, no damages.\n\n\n\n\n\n\n\nPlease reply by email.\n\nThank you.", [obj objectForKey: kDataKey],
                         @"Wrong body %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 3];
    STAssertEqualObjects(@"images", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"http://i50.tinypic.com/xe50k5.jpg", [obj objectForKey: kDataKey],
                         @"Wrong image URL %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 5];
    STAssertEqualObjects(@"images", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"http://i47.tinypic.com/eg3ek1.jpg", [obj objectForKey: kDataKey],
                         @"Wrong image URL %@", [obj objectForKey: kDataKey]);
}

- (void) testAdImages2 {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"ad" withType:@"json"];
    NSString* htmlString = [self.unitTestHelper contentsOfFile:@"EnAdImages2"];
    
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* ad =[parser parse:htmlString];
    STAssertTrue(15 == [ad count], @"Expected five items but found %lu", [ad count]);
    
    NSDictionary *obj;
    
    obj = [ad objectAtIndex: 0];
    STAssertEqualObjects(@"title", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"GAINT MOUNTAIN BIKE - $699 ( SO. BAY $ 699)", [obj objectForKey: kDataKey], @"Wrong date %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 1];
    STAssertEqualObjects(@"date", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"2012-09-25,  4:46AM PDT", [obj objectForKey: kDataKey], @"Wrong date %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 3];
    STAssertEqualObjects(@"images", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"http://images.craigslist.org/thumb/5I45K25P33Ef3Gc3J8c9hb1345756f604187a.jpg", [obj objectForKey: kDataKey],
                         @"Wrong image URL %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 9];
    STAssertEqualObjects(@"images", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"http://images.craigslist.org/thumb/5Ie5G95Fd3G53Me3pec9h1c988bc294781bb5.jpg", [obj objectForKey: kDataKey],
                         @"Wrong image URL %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 11];
    STAssertEqualObjects(@"location", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"SO. BAY $ 699", [obj objectForKey: kDataKey], @"Wrong posting ID %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 12];
    STAssertEqualObjects(@"body", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    //STAssertEqualObjects(@"GAINT MOUNTAIN BIKE (AC) SRAM, XTR, SHAMANO, COMPONENTS  ROC SHOCK PHYCO, BLUE, GREAT CONDO PAYED $ 1499oo ASKING $ 699 .",
      //                   [obj objectForKey: kDataKey], @"Wrong body %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 13];
    STAssertEqualObjects(@"postingID", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"3276932378", [obj objectForKey: kDataKey], @"Wrong posting ID %@", [obj objectForKey: kDataKey]);

}

- (void) testAdImages3 {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"ad" withType:@"json"];
    NSString* htmlString = [self.unitTestHelper contentsOfFile:@"RusAdImages3"];
    
    ParametrizedSAXParser* parser = [[ParametrizedSAXParser alloc] initWithDataMap:dataMap];
    NSArray* ad =[parser parse:htmlString];

    STAssertTrue(16 == [ad count], @"Expected five items but found %lu", [ad count]);
    
    NSDictionary *obj;
    
    obj = [ad objectAtIndex: 0];
    STAssertEqualObjects(@"title", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"Слід dolly Камера do", [obj objectForKey: kDataKey], @"Wrong date %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 1];
    STAssertEqualObjects(@"date", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"2012-09-22, 11:20PM EEST", [obj objectForKey: kDataKey], @"Wrong date %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 2];
    STAssertEqualObjects(@"mailto", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"mailto:dbrk7-3258787977@sale.craigslist.org?subject=%20dolly%20%20do&body=%0A%0Ahttp%3A%2F%2Fukraine.craigslist.org%2Fphd%2F3258787977.html%0A", [obj objectForKey: kDataKey], @"Wrong mailto %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 3];
    STAssertEqualObjects(@"images", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"http://i1093.photobucket.com/albums/i423/paktazh1/Untitled-2.jpg", [obj objectForKey: kDataKey],
                         @"Wrong image URL %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 7];
    STAssertEqualObjects(@"images", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"http://i1093.photobucket.com/albums/i423/paktazh1/hhfgh.jpg", [obj objectForKey: kDataKey],
                         @"Wrong image URL %@", [obj objectForKey: kDataKey]);
    
    obj = [ad objectAtIndex: 13];
    STAssertEqualObjects(@"body", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    
    obj = [ad objectAtIndex: 14];
    STAssertEqualObjects(@"postingID", [obj objectForKey: kFieldNameKey], @"Wrong field name %@", [obj objectForKey: kFieldNameKey]);
    STAssertEqualObjects(@"3258787977", [obj objectForKey: kDataKey], @"Wrong posting ID %@", [obj objectForKey: kDataKey]);
    
    [parser release];
}

@end
