//
//  PSAXAdSearchParserTest.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/1/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "GlobalFunctions.h"
#import "UnitTestDefs.h"
#import "UnitTestHelper.h"
#import "Defs.h"
#import "AdData.h"
#import "AdSearchResultsProcessor.h"

#import "AdSearchResultsProcessorTest.h"
#import "ParametrizedSAXParser.h"

@implementation AdSearchResultsProcessorTest

- (void) testAppliancesSearchParsing {
    //return;
    
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adsearch" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_APPLIANCES_SEARCH];
    
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlString];
    
    AdSearchResultsProcessor* processor = [[[AdSearchResultsProcessor alloc] init] autorelease];
    NSDictionary* adsDict = (NSDictionary*)[processor parseResultArray:resultArray];
    
	NSArray* groupNames = [adsDict objectForKey:KEY_GROUP_NAMES];
	NSArray* groups = [adsDict objectForKey:KEY_GROUPS];
	STAssertTrue([groupNames count]==1,@"groupNames.count=%d",[groupNames count]);
	STAssertTrue([groups count]==1,@"gropus count=%d",[groups count]);
	NSString* groupName = [groupNames objectAtIndex:0];
	STAssertTrue([groupName isEqualToString:@"Listings 1 - 100 out of 609"],@"groupName=%@",groupName);
	NSArray* group = [groups objectAtIndex:0];
    
	STAssertTrue(100==[group count],@"group.count=%d",[group count]);
	AdData* adData = [group objectAtIndex:0];
	STAssertTrue(IsStringWithAnyText(adData.title),@"");
	STAssertTrue([adData.title isEqualToString:@"Nov 10 - Medium Size 10 Cubic Foot Fridge - Free Delivery - Warranty"],@"title=%@",adData.title);
	STAssertTrue([adData.link isEqualToString:@"http://losangeles.craigslist.org/lac/app/2052168054.html"],@"link=%@",adData.link);
	STAssertTrue([adData.price isEqualToString:@"$135"],@"price=%@",adData.price);
	STAssertTrue([adData.place isEqualToString:@"Los Angeles Area"],@"place=%@",adData.place);
    
	NSString* nextURL = [adsDict objectForKey:KEY_NEXT_URL];
	STAssertTrue([nextURL isKindOfClass:[NSString class]],@"");
	if ([nextURL isKindOfClass:[NSString class]]) {
		STAssertTrue([nextURL isEqualToString:@"http://losangeles.craigslist.org/search/app?query=fridge&srchType=A&minAsk=&maxAsk=&s=100"],@"nextURL=%@",nextURL);
	}
}

- (void) testW4WSearchParsing {
    //<p without class 'row'
    return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adsearch" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_W4W_SEARCH];
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlString];
    
    AdSearchResultsProcessor* processor = [[[AdSearchResultsProcessor alloc] init] autorelease];
    processor.requestInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"http://losangeles.craigslist.org/ppp/",KEY_TOP_CATEGORY_HREF,nil];
    NSDictionary* adsDict = (NSDictionary*)[processor parseResultArray:resultArray];

	NSArray* groupNames = [adsDict objectForKey:KEY_GROUP_NAMES];
	NSArray* groups = [adsDict objectForKey:KEY_GROUPS];
	STAssertTrue([groupNames count]==1,@"groupNames.count=%d",[groupNames count]);
	STAssertTrue([groups count]==1,@"gropus count=%d",[groups count]);
	NSString* groupName = [groupNames objectAtIndex:0];
	STAssertTrue([groupName isEqualToString:@"Listings 1 - 38 out of 38"],@"groupName=%@",groupName);
	NSArray* group = [groups objectAtIndex:0];
	STAssertTrue(38==[group count],@"group.count=%d",[group count]);
	AdData* adData = [group objectAtIndex:0];
	STAssertTrue(IsStringWithAnyText(adData.title),@"");
	STAssertTrue([adData.title isEqualToString:@"Nov  9 - looking for friends to go out with"],@"title=%@",adData.title);
	STAssertTrue([adData.link isEqualToString:@"http://losangeles.craigslist.org/lac/w4w/2051986357.html"],@"link=%@",adData.link);
	STAssertTrue([adData.price isEqualToString:@"29"],@"price=%@",adData.price);
	STAssertNil(adData.place,@"place=%@",adData.place);
    
	adData = [group objectAtIndex:1];
	STAssertTrue(IsStringWithAnyText(adData.title),@"");
	STAssertNil(adData.price,@"price=%@",adData.price);
	STAssertTrue([adData.place isEqualToString:@"WEST LA"],@"place=%@",adData.place);
    
	NSString* nextURL = [adsDict objectForKey:KEY_NEXT_URL];
	//no next url here
	STAssertTrue([nextURL isKindOfClass:[NSNull class]],@"");
}

- (void) testJobsSearchParsing {
    //<p without class 'row'
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adsearch" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_JOBS_SEARCH];
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlString];
    
    AdSearchResultsProcessor* processor = [[[AdSearchResultsProcessor alloc] init] autorelease];
    NSDictionary* adsDict = (NSDictionary*)[processor parseResultArray:resultArray];

	NSArray* groupNames = [adsDict objectForKey:KEY_GROUP_NAMES];
	NSArray* groups = [adsDict objectForKey:KEY_GROUPS];
	STAssertTrue([groupNames count]==1,@"groupNames.count=%d",[groupNames count]);
	STAssertTrue([groups count]==1,@"gropus count=%d",[groups count]);
	NSString* groupName = [groupNames objectAtIndex:0];
	STAssertTrue([groupName isEqualToString:@"Listings 1 - 69 out of 69"],@"groupName=%@",groupName);
    return;
	NSArray* group = [groups objectAtIndex:0];
	STAssertTrue(69==[group count],@"group.count=%d",[group count]);
	AdData* adData = [group objectAtIndex:0];
	STAssertTrue(IsStringWithAnyText(adData.title),@"");
	STAssertTrue([adData.title isEqualToString:@"Nov  9 - Call Center Agents- 1-800LoanMart"],@"title=%@",adData.title);
	STAssertNil(adData.price,@"");
	STAssertTrue([adData.place isEqualToString:@"Encino, CA"],@"place=%@",adData.place);
	
	adData = [group objectAtIndex:1];
	STAssertTrue(IsStringWithAnyText(adData.title),@"");
	STAssertNil(adData.price,@"price=%@",adData.price);
	STAssertTrue([adData.place isEqualToString:@"Encino, CA"],@"place=%@",adData.place);
	
	NSString* nextURL = [adsDict objectForKey:KEY_NEXT_URL];
	//no next url here
	STAssertTrue([nextURL isKindOfClass:[NSNull class]],@"");
}

- (void) testHousingSearchParsing {
    //<p without class 'row'
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adsearch" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_HOUSING_SEARCH];
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlString];
    
    AdSearchResultsProcessor* processor = [[[AdSearchResultsProcessor alloc] init] autorelease];
    NSDictionary* adsDict = (NSDictionary*)[processor parseResultArray:resultArray];

	NSArray* groupNames = [adsDict objectForKey:KEY_GROUP_NAMES];
	NSArray* groups = [adsDict objectForKey:KEY_GROUPS];
	STAssertTrue([groupNames count]==1,@"groupNames.count=%d",[groupNames count]);
	STAssertTrue([groups count]==1,@"gropus count=%d",[groups count]);
	NSString* groupName = [groupNames objectAtIndex:0];
	STAssertTrue([groupName isEqualToString:@"Listings 1 - 100 out of 879"],@"groupName=%@",groupName);
    return;
	NSArray* group = [groups objectAtIndex:0];
	STAssertTrue(100==[group count],@"group.count=%d",[group count]);
	AdData* adData = [group objectAtIndex:0];
	STAssertTrue(IsStringWithAnyText(adData.title),@"");
	STAssertTrue([adData.title isEqualToString:@"Nov 10 - $800000 WANTED : A big lot house in the Valley - CASH Buyer - Owner Finance op"],@"title=%@",adData.title);
    //	STAssertTrue([adData.price isEqualToString:@"$800000"],@"price=%@",adData.price);
	STAssertTrue([adData.place isEqualToString:@"Tarzana"],@"place=%@",adData.place);
	
	adData = [group objectAtIndex:1];
	STAssertTrue(IsStringWithAnyText(adData.title),@"");
    //	STAssertTrue([adData.price isEqualToString:@"$3000 / 3br"],@"price=%@",adData.price);
	STAssertTrue([adData.place isEqualToString:@"Manhattan Beach"],@"place=%@",adData.place);
	
	NSString* nextURL = [adsDict objectForKey:KEY_NEXT_URL];
	//no next url here
	STAssertTrue([nextURL isKindOfClass:[NSString class]],@"");
	
}

- (void) testNoResultsSearchParsing {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adsearch" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_NORESULTS_SEARCH];
	STAssertTrue([htmlString length]>0,@"");
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlString];
    
    AdSearchResultsProcessor* processor = [[[AdSearchResultsProcessor alloc] init] autorelease];
    NSDictionary* adsDict = (NSDictionary*)[processor parseResultArray:resultArray];

	NSArray* groupNames = [adsDict objectForKey:KEY_GROUP_NAMES];
	NSArray* groups = [adsDict objectForKey:KEY_GROUPS];
	STAssertTrue([groupNames count]==0,@"groupNames.count=%d",[groupNames count]);
	STAssertTrue([groups count]==0,@"gropus count=%d",[groups count]);
}

- (void) testJewelrySearch {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adsearch" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_JEWELRY_SEARCH];
	STAssertTrue([htmlString length]>0,@"");
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlString];
    
    AdSearchResultsProcessor* processor = [[[AdSearchResultsProcessor alloc] init] autorelease];
    NSDictionary* adsDict = (NSDictionary*)[processor parseResultArray:resultArray];

	NSArray* groupNames = [adsDict objectForKey:KEY_GROUP_NAMES];
	NSArray* groups = [adsDict objectForKey:KEY_GROUPS];
	STAssertTrue([groupNames count]==1,@"groupNames.count=%d",[groupNames count]);
    NSString* groupName = [groupNames objectAtIndex:0];
	STAssertTrue([groupName isEqualToString:@"Zero LOCAL results found. Here are some from NEARBY areas..."],@"Wrong groupName=%@",groupName);
	STAssertTrue([groups count]==1,@"gropus count=%d",[groups count]);
}

- (void) sublocationNamesDictionatyTesting:(NSDictionary*)sublocationNamesDictionary{
    
    STAssertNotNil(sublocationNamesDictionary, @"Your sublocation names dictionaty is nil");
    STAssertTrue([[sublocationNamesDictionary allKeys] count]==6,@"Abbreviation count for Chicago sublocations must be 6, but you have=%d",[[sublocationNamesDictionary allKeys] count]);
    
    NSArray *subLocNames = [NSArray arrayWithObjects:@"city of chicago",@"north chicagoland",@"west chicagoland",@"south chicagoland",@"northwest indiana",@"northwest suburbs", nil];
    for(NSString* key in [sublocationNamesDictionary allKeys]){
        STAssertTrue([subLocNames containsObject:[sublocationNamesDictionary objectForKey:key]],@"Your dictionary is incorrect (incorrect element = %@)",[sublocationNamesDictionary objectForKey:key]);
    }
}

- (void) testAllOfSubCategorySublocationParsing {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adsearch" withType:@"json"];
	NSString* htmlStringAllOfPoliticsChicagoSearch = [self.unitTestHelper contentsOfFile:FILE_CHICAGO_ALLOFF_POLITICS_SEARCH];
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlStringAllOfPoliticsChicagoSearch];
    
    AdSearchResultsProcessor* processor = [[[AdSearchResultsProcessor alloc] init] autorelease];
	[processor setURL:@"http://chicago.craigslist.org/search/pol?query=1&srchType=A"];
    NSDictionary* adsDict = (NSDictionary*)[processor parseResultArray:resultArray];
    
    [self sublocationNamesDictionatyTesting:[adsDict objectForKey:KEY_SUBLOCATIONS]];
}

- (void) testAllOfTopCategorySublocationParsing {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adsearch" withType:@"json"];
	NSString* htmlStringAllOfServicesChicagoSearch = [self.unitTestHelper contentsOfFile:FILE_CHICAGO_ALLOFF_SERVICES_SEARCH];
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlStringAllOfServicesChicagoSearch];
    
    AdSearchResultsProcessor* processor = [[[AdSearchResultsProcessor alloc] init] autorelease];
	[processor setURL:@"http://chicago.craigslist.org/search/bbb?query=1&srchType=A"];
    NSDictionary* adsDict = (NSDictionary*)[processor parseResultArray:resultArray];
    
    [self sublocationNamesDictionatyTesting:[adsDict objectForKey:KEY_SUBLOCATIONS]];
}

- (void) testChosenSublocationParsing {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adsearch" withType:@"json"];
    NSString* htmlStringCityOfChicagoSearch = [self.unitTestHelper contentsOfFile:FILE_CHICAGO_CITY_CUSTOMERSURVICE_SEARCH];
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlStringCityOfChicagoSearch];
    
    AdSearchResultsProcessor* processor = [[[AdSearchResultsProcessor alloc] init] autorelease];
	[processor setURL:@"http://chicago.craigslist.org/search/csr/chc?query=1&srchType=A"];
    NSDictionary* adsDict = (NSDictionary*)[processor parseResultArray:resultArray];
    
    [self sublocationNamesDictionatyTesting:[adsDict objectForKey:KEY_SUBLOCATIONS]];
}

- (void) testBooksSearch {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adsearch" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_BOOKS_SEARCH];
    ParametrizedSAXParser* parser = [[[ParametrizedSAXParser alloc] initWithDataMap:dataMap] autorelease];
    NSArray* resultArray = [parser parse:htmlString];
    
    AdSearchResultsProcessor* processor = [[[AdSearchResultsProcessor alloc] init] autorelease];
	[processor setURL:@"http://losangeles.craigslist.org/app/index.html"];
    NSDictionary* adsDict = (NSDictionary*)[processor parseResultArray:resultArray];
    
	NSArray* groupNames = [adsDict objectForKey:KEY_GROUP_NAMES];
    NSArray* groups = [adsDict objectForKey:KEY_GROUPS];
	STAssertTrue([groupNames count]==1,@"groupNames.count=%d",[groupNames count]);
	STAssertTrue([groups count]==1,@"gropus count=%d",[groups count]);
	NSString* groupName = [groupNames objectAtIndex:0];
	STAssertTrue([groupName isEqualToString:@"Listings 1 - 100 out of 1000"],@"groupName=%@",groupName);
	NSArray* group = [groups objectAtIndex:0];
    
	STAssertTrue(100==[group count],@"group.count=%d",[group count]);
	AdData* adData = [group objectAtIndex:0];
	STAssertTrue(IsStringWithAnyText(adData.title),@"");
	STAssertTrue([adData.title isEqualToString:@"Sep 17 - high school textbook books for sale $5 to $10 - Updated List"],@"title=%@",adData.title);
	STAssertTrue([adData.link isEqualToString:@"http://losangeles.craigslist.org/sgv/bks/3248680018.html"],@"link=%@",adData.link);
	STAssertTrue([adData.price isEqualToString:@"$10"],@"price=%@",adData.price);
	STAssertTrue([adData.place isEqualToString:@"pasadena area"],@"place=%@",adData.place);
    
	NSString* nextURL = [adsDict objectForKey:KEY_NEXT_URL];
	STAssertTrue([nextURL isKindOfClass:[NSString class]],@"");
	if ([nextURL isKindOfClass:[NSString class]]) {
		STAssertTrue([nextURL isEqualToString:@"http://losangeles.craigslist.org/search/bka?query=book&srchType=A&s=100"],@"nextURL=%@",nextURL);
	}
}

- (void) testPWithoutRow {
    //<p without class 'row'
    //return;
    /*
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adsearch" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:@"PWithoutRow"];
    PSAXAdSearchParser* parser = [[[PSAXAdSearchParser alloc] initWithDataMap:dataMap] autorelease];
    parser.requestInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"http://losangeles.craigslist.org/ppp/",KEY_TOP_CATEGORY_HREF,nil];
	NSDictionary* adsDict = (NSDictionary*)[parser parseHTML:htmlString];
    
    //NSLog(@"RES %@", adsDict);
    */
}

@end
