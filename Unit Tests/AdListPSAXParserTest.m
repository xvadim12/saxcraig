//
//  AdListPSAXParserTest.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/28/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "Defs.h"
#import "UnitTestDefs.h"
#import "UnitTestHelper.h"
#import "AdData.h"
#import "PSAXAdListParser.h"
#import "AdListPSAXParserTest.h"

@implementation AdListPSAXParserTest

- (void) testAppliancesParsing {
    
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adlist" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_APPLIANCES_LIST];
    PSAXAdListParser* parser = [[[PSAXAdListParser alloc] initWithDataMap:dataMap] autorelease];
	[parser setURL:@"http://losangeles.craigslist.org/app/index.html"];
    
	NSDictionary* adsDict = (NSDictionary*)[parser parseHTML:htmlString];
    
	NSArray* groupNames = [adsDict objectForKey:KEY_GROUP_NAMES];
	NSArray* groups = [adsDict objectForKey:KEY_GROUPS];
	STAssertTrue([groupNames count]==2,@"groupNames.count=%d",[groupNames count]);
	STAssertTrue([groups count]==2,@"gropus count=%d",[groups count]);
	NSArray* group = [groups objectAtIndex:0];
	STAssertTrue([group count]>0,@"");
	AdData* adData = [group objectAtIndex:0];
	//STAssertTrue(IsStringWithAnyText(adData.title),@"");
	STAssertTrue([adData.title isEqualToString:@"WHIRLPOOL THIN TWIN SERIES WASHER/DRYER COMBO"],@"title=%@",adData.title);
	STAssertTrue([adData.link isEqualToString:@"http://losangeles.craigslist.org/sgv/app/2041637838.html"],@"link=%@",adData.link);
	//STAssertTrue([adData.price isEqualToString:@"$475"],@"price=%@",adData.price);
	STAssertTrue([adData.place isEqualToString:@"SAN DIMAS"],@"place=%@",adData.place);
    STAssertTrue([adData.thumbnailLink isEqualToString:@"http://images.craigslist.org/medium/3n43m03p55V15O15S0ab4b31e8fe02f61131d.jpg"],
                 @"thumbnail=%@",adData.thumbnailLink);
    
	NSString* nextURL = [adsDict objectForKey:KEY_NEXT_URL];
	STAssertTrue([nextURL isKindOfClass:[NSString class]],@"");
	STAssertTrue([nextURL isEqualToString:@"http://losangeles.craigslist.org/app/index100.html"],@"nextURL=%@",nextURL);
}

- (void) testSqftParcing{
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"adlist" withType:@"json"];
	NSString* htmlString1 = [self.unitTestHelper contentsOfFile:FILE_SFBAYAREA_OFFICE_AD_LIST];
	NSString* htmlString2 = [self.unitTestHelper contentsOfFile:FILE_APPLIANCES_LIST];
    
    PSAXAdListParser* parser = [[[PSAXAdListParser alloc] initWithDataMap:dataMap] autorelease];
	
	[parser setURL:@"http://sfbay.craigslist.org/off/"];
	NSDictionary* adsDict1 = (NSDictionary*)[parser parseHTML:htmlString1];
	NSNumber* sqft1 = [adsDict1 objectForKey:KEY_SQFT];
	STAssertTrue([sqft1 boolValue],@"for this list sqft must be true");
	
	[parser setURL:@"http://losangeles.craigslist.org/app/index.html"];
	NSDictionary* adsDict2 = (NSDictionary*)[parser parseHTML:htmlString2];
	NSNumber* sqft2 = [adsDict2 objectForKey:KEY_SQFT];
	STAssertFalse([sqft2 boolValue],@"for this list sqft must be false");
}

@end
