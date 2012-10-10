//
//  AdListPSAXParserTest.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/28/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "Defs.h"
#import "GlobalFunctions.h"
#import "UnitTestDefs.h"
#import "UnitTestHelper.h"
#import "AdData.h"
#import "AdListResultsProcessor.h"
#import "AdListResultsProcessorTest.h"

#import "ParametrizedSAXParser.h"

@implementation AdListResultsProcessorTest

- (void) testNeighborhoodsParcing{
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adlist" withType:@"json"];
	NSString* htmlString1 = [self.unitTestHelper contentsOfFile:FILE_PENINSULA_AD_LIST];
	NSString* htmlString2 = [self.unitTestHelper contentsOfFile:FILE_APPLIANCES_LIST];
    
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlString1];
    
    AdListResultsProcessor* processor = [[[AdListResultsProcessor alloc] init] autorelease];
	[processor setURL:@"http://sfbay.craigslist.org/pen/hhh/"];
    NSDictionary* adsDict1 = (NSDictionary*)[processor parseResultArray:resultArray];
    
	NSDictionary* neighborhoodsDict1 = [adsDict1 objectForKey:KEY_NEIGHBORHOODS];
	STAssertTrue([neighborhoodsDict1 count]==23,@"neighborhoods count=%d",[neighborhoodsDict1 count]);
	STAssertTrue([[neighborhoodsDict1 objectForKey:@"foster city"] intValue] == 77,
				 @"your dictionary is incorrect, your foster city value is %d",[[neighborhoodsDict1 objectForKey:@"foster city"] intValue]);

	[processor setURL:@"http://losangeles.craigslist.org/app/index.html"];
    resultArray = [parser parse:htmlString2];
    NSDictionary* adsDict2 = (NSDictionary*)[processor parseResultArray:resultArray];
	NSDictionary* neighborhoodsDict2 = [adsDict2 objectForKey:KEY_NEIGHBORHOODS];
	STAssertTrue((NSObject*)neighborhoodsDict2==[NSNull null],@"neighborhoods dictionary for this list must be nil");
}

- (void) testAppliancesParsing {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adlist" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_APPLIANCES_LIST];

    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlString];
    
    AdListResultsProcessor* processor = [[[AdListResultsProcessor alloc] init] autorelease];
	[processor setURL:@"http://losangeles.craigslist.org/app/index.html"];
    
    NSDictionary* adsDict = (NSDictionary*)[processor parseResultArray:resultArray];
    
	NSArray* groupNames = [adsDict objectForKey:KEY_GROUP_NAMES];
	NSArray* groups = [adsDict objectForKey:KEY_GROUPS];
	STAssertTrue([groupNames count]==2,@"groupNames.count=%d",[groupNames count]);
	STAssertTrue([groups count]==2,@"gropus count=%d",[groups count]);
	NSArray* group = [groups objectAtIndex:0];
	STAssertTrue([group count]>0,@"");
	AdData* adData = [group objectAtIndex:0];
	STAssertTrue(IsStringWithAnyText(adData.title),@"");
	STAssertTrue([adData.title isEqualToString:@"WHIRLPOOL THIN TWIN SERIES WASHER/DRYER COMBO"],@"title=%@",adData.title);
	STAssertTrue([adData.link isEqualToString:@"http://losangeles.craigslist.org/sgv/app/2041637838.html"],@"link=%@",adData.link);
	STAssertTrue([adData.price isEqualToString:@"$475"],@"price=%@",adData.price);
	STAssertTrue([adData.place isEqualToString:@"SAN DIMAS"],@"place=%@",adData.place);
    STAssertTrue([adData.thumbnailLink isEqualToString:@"http://images.craigslist.org/medium/3n43m03p55V15O15S0ab4b31e8fe02f61131d.jpg"],
                 @"thumbnail=%@",adData.thumbnailLink);
    
	NSString* nextURL = [adsDict objectForKey:KEY_NEXT_URL];
	STAssertTrue([nextURL isKindOfClass:[NSString class]],@"");
	STAssertTrue([nextURL isEqualToString:@"http://losangeles.craigslist.org/app/index100.html"],@"nextURL=%@",nextURL);
}

- (void) testSqftParcing{
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adlist" withType:@"json"];
	NSString* htmlString1 = [self.unitTestHelper contentsOfFile:FILE_SFBAYAREA_OFFICE_AD_LIST];
	NSString* htmlString2 = [self.unitTestHelper contentsOfFile:FILE_APPLIANCES_LIST];
    
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlString1];
    
    AdListResultsProcessor* processor = [[[AdListResultsProcessor alloc] init] autorelease];
	
	[processor setURL:@"http://sfbay.craigslist.org/off/"];
    NSDictionary* adsDict1 = (NSDictionary*)[processor parseResultArray:resultArray];
	NSNumber* sqft1 = [adsDict1 objectForKey:KEY_SQFT];
	STAssertTrue([sqft1 boolValue],@"for this list sqft must be true");
	
	[processor setURL:@"http://losangeles.craigslist.org/app/index.html"];
    resultArray = [parser parse:htmlString2];
    NSDictionary* adsDict2 = (NSDictionary*)[processor parseResultArray:resultArray];
	NSNumber* sqft2 = [adsDict2 objectForKey:KEY_SQFT];
	STAssertFalse([sqft2 boolValue],@"for this list sqft must be false");
}

- (void) sublocationNamesDictionatyTesting:(NSDictionary*)sublocationNamesDictionary{
    
    STAssertNotNil(sublocationNamesDictionary, @"Your sublocation names dictionaty is nil");
    STAssertTrue([[sublocationNamesDictionary allKeys] count]==6,
                 @"Abbreviation count for Chicago sublocations must be 6, but you have=%d",[[sublocationNamesDictionary allKeys] count]);
    
    NSArray *subLocNames = [NSArray arrayWithObjects:@"city of chicago",@"north chicagoland",@"west chicagoland",@"south chicagoland",@"northwest indiana",@"northwest suburbs", nil];
    NSArray *subLocAbbrs = [NSArray arrayWithObjects:@"nch", @"chc", @"nwc", @"wcl", @"sox", @"nwi", nil];
    
    for(NSString* key in [sublocationNamesDictionary allKeys]){
        STAssertTrue([subLocNames containsObject:[sublocationNamesDictionary objectForKey:key]],@"Your dictionary is incorrect (incorrect element = %@)",[sublocationNamesDictionary objectForKey:key]);
        STAssertTrue([subLocAbbrs containsObject:key],@"Your dictionary is incorrect (incorrect element = %@)", key);
    }
}

- (void) testAllOfSubCategorySublocationParsing {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adlist" withType:@"json"];
	NSString* htmlStringAllOfPoliticsChicago = [self.unitTestHelper contentsOfFile:FILE_CHICAGO_ALLOFF_POLITICS];
    
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlStringAllOfPoliticsChicago];
    
    AdListResultsProcessor* processor = [[[AdListResultsProcessor alloc] init] autorelease];
    
	[processor setURL:@"http://chicago.craigslist.org/pol/"];
    NSDictionary* adsDict = (NSDictionary*)[processor parseResultArray:resultArray];
    
    [self sublocationNamesDictionatyTesting:[adsDict objectForKey:KEY_SUBLOCATIONS]];
}

- (void) testAllOfTopCategorySublocationParsing {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adlist" withType:@"json"];
	NSString* htmlStringAllOfServicesChicago = [self.unitTestHelper contentsOfFile:FILE_CHICAGO_ALLOFF_SERVICES];
    
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlStringAllOfServicesChicago];
    
    AdListResultsProcessor* processor = [[[AdListResultsProcessor alloc] init] autorelease];

	[processor setURL:@"http://chicago.craigslist.org/bbb/"];
    NSDictionary* adsDict = (NSDictionary*)[processor parseResultArray:resultArray];
    
    [self sublocationNamesDictionatyTesting:[adsDict objectForKey:KEY_SUBLOCATIONS]];
}

- (void) testChosenSublocationParsing {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adlist" withType:@"json"];
    NSString* htmlStringCityOfChicago = [self.unitTestHelper contentsOfFile:FILE_CHICAGO_CITY_CUSTOMERSURVICE];
    
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlStringCityOfChicago];
    
    AdListResultsProcessor* processor = [[[AdListResultsProcessor alloc] init] autorelease];
    
	[processor setURL:@"http://chicago.craigslist.org/chc/csr/"];
    NSDictionary* adsDict = (NSDictionary*)[processor parseResultArray:resultArray];

    [self sublocationNamesDictionatyTesting:[adsDict objectForKey:KEY_SUBLOCATIONS]];
}

- (void) testBooksAndMagAd {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adlist" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_BOOKS_AND_MAGS];
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlString];
    
    AdListResultsProcessor* processor = [[[AdListResultsProcessor alloc] init] autorelease];
	[processor setURL:@"http://losangeles.craigslist.org/app/index.html"];
    
    NSDictionary* adsDict = (NSDictionary*)[processor parseResultArray:resultArray];
    
	NSArray* groupNames = [adsDict objectForKey:KEY_GROUP_NAMES];
    
	NSArray* groups = [adsDict objectForKey:KEY_GROUPS];
	STAssertTrue([groupNames count]==1,@"groupNames.count=%d",[groupNames count]);
    STAssertEqualObjects([groupNames objectAtIndex:0], @"Tue Sep 11", @"group name=%@", [groupNames objectAtIndex:0]);
	STAssertTrue([groups count]==1,@"gropus count=%d",[groups count]);
	NSArray* group = [groups objectAtIndex:0];
	STAssertTrue([group count] == 100, @"Wrong count of ads %@", [group count]);
	AdData* adData = [group objectAtIndex:0];
    STAssertEqualObjects(adData.title, @"THE PLAYMATE BOOK", @"adData.title=%@", adData.title);
    STAssertEqualObjects(adData.price, @"$30", @"adData.ptice=%@", adData.price);
    STAssertEqualObjects(adData.place, @"Studio City", @"adData.place=%@", adData.place);
    STAssertEqualObjects(adData.link, @"http://losangeles.craigslist.org/sfv/bks/3253676408.html", @"adData.place=%@", adData.place);
    
    adData = [group objectAtIndex:99];
    STAssertEqualObjects(adData.title, @"Sociology (Rio Hondo) ISBN: 9780136016823", @"adData.title=%@", adData.title);
    STAssertEqualObjects(adData.price, @"$40", @"adData.ptice=%@", adData.price);
    STAssertEqualObjects(adData.place, @"Rio Hondo", @"adData.place=%@", adData.place);
    STAssertEqualObjects(adData.link, @"http://losangeles.craigslist.org/sgv/bks/3254846603.html", @"adData.place=%@", adData.place);
    
    STAssertEqualObjects([adsDict objectForKey:KEY_NEXT_URL], @"http://losangeles.craigslist.org/app/index100.html", @"Link next=%@", [adsDict objectForKey:KEY_NEXT_URL]);
}

@end
