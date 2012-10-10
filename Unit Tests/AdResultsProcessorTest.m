//
//  AdPSAXParserTest.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/27/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "Defs.h"
#import "UnitTestDefs.h"
#import "UnitTestHelper.h"
#import "AdPSAXParserTest.h"
#import "PSAXAdParser.h"
#import "AdData.h"

@implementation AdPSAXParserTest

- (void) testTattooAd {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"ad" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_TATTOO_AD];
    
    PSAXAdParser* parser = [[[PSAXAdParser alloc] initWithDataMap:dataMap] autorelease];
    parser.requestInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"http://losangeles.craigslist.org/sss/",KEY_TOP_CATEGORY_HREF,nil];
    
    AdData* adData=(AdData*)[parser parseHTML:htmlString];
    
    STAssertTrue([adData.title isEqualToString:@"TATTOO KIT"],@"adData.title=%@",adData.title);
	STAssertTrue([adData.body length]>0,@"your body is empty");
	STAssertTrue([adData.imageURLs count]==4,@"adData.imageURLs.count=%d",[adData.imageURLs count]);
	STAssertTrue([adData.postingID isEqualToString:@"2040042795"],@"adData.postingID=%@",adData.postingID);
	STAssertTrue([adData.price isEqualToString:@"$100"],@"adData.price=%@",adData.price);
	STAssertTrue([adData.place isEqualToString:@"626"],@"adData.place=%@",adData.place);
	STAssertTrue([[adData.date description] isEqualToString:@"2010-11-03 15:26:00 +0000"],
				 @"adData.date=%@",[adData.date description]);
	STAssertNil(adData.phone,@"phone number for this ad must be nil");
//	STAssertNotNil(adData.relativeTime,@"your time is nil");
	STAssertNotNil(adData.descr,@"your description is nil");
    STAssertEqualObjects(adData.descr, @"TATTOO KIT with everything you need to get started tattooing, foot pedal clip cord power supply, 1 machine, kuro sumi ink, ink caps, tubes,needles, transfer paper, allen rench set with o-rings,gromets, and rubber bands .. Also have diff kits TEXT or call NINE-O-NINE 455-2306",
                         @"adData.descr=%@", adData.descr);
//	STAssertFalse(adData.isFavorite,@"this ad is not faforite");
	STAssertNil(adData.mailto,@"mailto url for this ad must be nil");
	STAssertNil(adData.replyURL,@"reply url for this ad must be nil");
    
}

- (void) testApartmentAd {
    return;
    //broken file </div> for <div id=userbody> is absent
    //and ad body with tags
    //TODO: Fix
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"ad" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_APARTMENT_AD];
	PSAXAdParser* parser = [[[PSAXAdParser alloc] initWithDataMap:dataMap] autorelease];
	parser.requestInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"http://losangeles.craigslist.org/hhh/",KEY_TOP_CATEGORY_HREF,nil];
    AdData* adData=(AdData*)[parser parseHTML:htmlString];
	
	
	STAssertTrue([adData.title isEqualToString:@"^^  Modernised ^^ Sparkling Swimming Pool  ^^ CLOSE 2 COUNTRY Club ^^ Appropriat"],
				 @"adData.title=%@",adData.title);
	STAssertTrue([adData.body length]>0,@"your body is empty");
	STAssertTrue([adData.imageURLs count]==0,@"adData.imageURLs.count=%d",[adData.imageURLs count]);
	STAssertTrue([adData.postingID isEqualToString:@"2041507829"],@"adData.postingID=%@",adData.postingID);
	STAssertTrue([adData.price isEqualToString:@"$1551 / 2br"],@"adData.price=%@",adData.price);
	STAssertTrue([adData.place isEqualToString:@"Prime LOCATION"],@"adData.place=%@",adData.place);
	STAssertNil(adData.phone,@"phone number for this ad must be nil");
	STAssertTrue([[adData.date description] isEqualToString:@"2010-11-04 08:55:00 +0000"],
				 @"adData.date=%@",[adData.date description]);
//	STAssertNotNil(adData.relativeTime,@"your time is nil");
	STAssertNotNil(adData.descr,@"your description is nil");
//	STAssertFalse(adData.isFavorite,@"this ad is not faforite");
	STAssertNil(adData.mailto,@"mailto url for this ad must be nil");
	STAssertNil(adData.replyURL,@"reply url for this ad must be nil");
}

- (void) testRefrigeratorAd {
    //return;
    //File without form with PostingID, only text in body
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"ad" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_REFRIGERATOR_AD];
    PSAXAdParser* parser = [[[PSAXAdParser alloc] initWithDataMap:dataMap] autorelease];
	parser.requestInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"http://losangeles.craigslist.org/sss/",KEY_TOP_CATEGORY_HREF,nil];
    AdData* adData=(AdData*)[parser parseHTML:htmlString];

	
	STAssertTrue([adData.title isEqualToString:@"ADMIRAL REFRIGERATOR IN EXCELLENT CONDTION"],
				 @"adData.title=%@",adData.title);
	STAssertTrue([adData.body length]>0,@"your body is empty");
	STAssertTrue([adData.imageURLs count]==3,@"adData.imageURLs.count=%d",[adData.imageURLs count]);
	STAssertTrue([adData.price isEqualToString:@"$120"],@"adData.price=%@",adData.price);
	STAssertTrue([adData.place isEqualToString:@"NORTH HOLLYWOOD"],@"adData.place=%@",adData.place);
	STAssertNil(adData.phone,@"phone number for this ad must be nil");
	STAssertTrue([[adData.date description] isEqualToString:@"2010-11-04 11:05:00 +0000"],
				 @"adData.date=%@",[adData.date description]);
	STAssertTrue([adData.postingID isEqualToString:@"2041542220"],@"adData.postingID=%@",adData.postingID);
	//STAssertNotNil(adData.relativeTime,@"your time is nil");
	STAssertNotNil(adData.descr,@"your description is nil");
	//STAssertFalse(adData.isFavorite,@"this ad is not faforite");
	STAssertTrue([adData.mailto isEqualToString:
				  @"mailto:sale-k5ugj-2041542220@craigslist.org?subject=ADMIRAL%20REFRIGERATOR%20IN%20EXCELLENT%20CONDTION%20-%20%24120%20(NORTH%20HOLLYWOOD)&body=%0A%0Ahttp%3A%2F%2Flosangeles.craigslist.org%2Fsfv%2Fapp%2F2041542220.html%0A"],@"adData.mailto=%@",adData.mailto);
	STAssertNil(adData.replyURL,@"reply url for this ad must be nil");
}

- (void) testHouseAd {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"ad" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_HOUSE_AD];
    PSAXAdParser* parser = [[[PSAXAdParser alloc] initWithDataMap:dataMap] autorelease];
	parser.requestInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"http://losangeles.craigslist.org/hhh/",KEY_TOP_CATEGORY_HREF,nil];
	AdData* adData = (AdData*) [parser parseHTML:htmlString];
	
	STAssertTrue([adData.title isEqualToString:@"BREATHTAKING Hollywood Home: Private, Gated, Resort Living"],
				 @"adData.title=%@",adData.title);
	STAssertTrue([adData.price isEqualToString:@"$1650 / 2br"],@"adData.price=%@",adData.price);
	STAssertTrue([adData.body length]>0,@"your body is empty");
	STAssertTrue([adData.imageURLs count]==4,@"adData.imageURLs.count=%d",[adData.imageURLs count]);
	STAssertTrue([adData.place isEqualToString:@"Hollywood"],@"adData.place=%@",adData.place);
	STAssertNil(adData.phone,@"phone number for this ad must be nil");
	STAssertTrue([adData.postingID isEqualToString:@"2052190170"],@"adData.postingID=%@",adData.postingID);
	STAssertTrue([[adData.date description] isEqualToString:@"2010-11-10 11:15:00 +0000"],
				 @"adData.date=%@",[adData.date description]);
	//STAssertNotNil(adData.relativeTime,@"your time is nil");
	STAssertNotNil(adData.descr,@"your description is nil");
	//STAssertFalse(adData.isFavorite,@"this ad is not faforite");
	STAssertTrue([adData.mailto isEqualToString:
				  @"mailto:hous-vhxut-2052190170@craigslist.org?subject=%241650%20%2F%202br%20-%20BREATHTAKING%20Hollywood%20Home%3A%20Private%2C%20Gated%2C%20Resort%20Living%20(Hollywood)&body=%0A%0Ahttp%3A%2F%2Flosangeles.craigslist.org%2Flac%2Fapa%2F2052190170.html%0A"],@"adData.mailto=%@",adData.mailto);
	STAssertNil(adData.replyURL,@"reply url for this ad must be nil");
}

- (void) testRusAdImages3 {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"ad" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_RUS_AD_IMAGES3];
    
    PSAXAdParser* parser = [[[PSAXAdParser alloc] initWithDataMap:dataMap] autorelease];
    parser.requestInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"http://ukraine.craigslist.org/phd",KEY_TOP_CATEGORY_HREF,nil];
    
    AdData* adData=(AdData*)[parser parseHTML:htmlString];
    
    NSString* descr = @"Слід dolly Камера dolly 750 USD Будь ласка відвідувати нас http://trackdolly.com/ Buy camera dolly for $99 Track dolly 750 Dealers well come http://trackdolly.com/ Buy camera dolly for $99 Track dolly 750 Dealers well come http://trackdolly.com/";
    STAssertEqualObjects(adData.descr, descr, @"Wrong descr $@", adData.descr);
    STAssertTrue(5 == [adData.imageURLs count],@"adData.imageURLs.count=%d",[adData.imageURLs count]);
    STAssertEqualObjects(adData.title, @"Слід dolly Камера do", @"adData.title=%@", adData.title);
    STAssertNil(adData.price, @"price must be nil");
    STAssertEqualObjects(adData.postingID, @"3258787977", @"adData.postingID=%@", adData.postingID);
    STAssertEqualObjects(adData.mailto,
                  @"mailto:dbrk7-3258787977@sale.craigslist.org?subject=%20dolly%20%20do&body=%0A%0Ahttp%3A%2F%2Fukraine.craigslist.org%2Fphd%2F3258787977.html%0A",
                  @"adData.mailto=%@",adData.mailto);
}

- (void) testEnAdImages1 {
    //return;
    NSString* dataMap = [self.unitTestHelper contentsOfFile:@"ad" withType:@"json"];
	NSString* htmlString = [self.unitTestHelper contentsOfFile:FILE_EN_AD_IMAGES1];
    
    PSAXAdParser* parser = [[[PSAXAdParser alloc] initWithDataMap:dataMap] autorelease];
    parser.requestInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"http://losangeles.craigslist.org/hhh/",KEY_TOP_CATEGORY_HREF,nil];
    
    AdData* adData=(AdData*)[parser parseHTML:htmlString];
    
    STAssertEqualObjects(@"2012-09-25 09:13:00 +0000", [adData.date description], @"adData.date %@", [adData.date description]);
    STAssertEqualObjects(adData.title, @"Who Moved My Cheese - $10", @"adData.title %@", adData.title);
    STAssertEqualObjects(adData.descr, @"BRAND NEW. Crispy pages, no damages. Please reply by email. Thank you.", @"adData.descr %@", adData.descr);
    //NSLog(@"PRICE %@", adData.price); - price was not extracted from title
    STAssertEqualObjects(adData.postingID, @"3283339813", @"adData.postingID %@", adData.postingID);
}

@end
