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

    NSString* htmlString = [self.unitTestHelper contentsOfFile:@"SimpleAdList"];

    NSString *stringDataMap = @"{\"html body.toc h4.ban\" :\
                                    {\
                                        \"fieldName\": \"listTitle\",\
                                        \"trimmedChars\": \" \",\
                                        \"type\" : 0\
                                    },\
                                 \"html body.toc p.row\" :\
                                    {\
                                        \"fieldName\": \"ads\",\
                                        \"type\" : 1\
                                    },\
                                \"html body.toc p.row a\" :\
                                    {\
                                        \"fieldName\": \"title\",\
                                        \"trimmedChars\": \" \",\
                                        \"type\" : 0,\
                                        \"attributes\" : {\
                                                \"href\": {\
                                                            \"fieldName\": \"link\",\
                                                            \"trimmedChars\": \" \"\
                                                          }\
                                                         }\
                                    },\
                                \"html body.toc p.row span.itempp\" :\
                                    {\
                                        \"fieldName\": \"price\",\
                                        \"trimmedChars\": \" \",\
                                        \"type\" : 0\
                                    },\
                                \"html body.toc p.row span.itempn\" :\
                                    {\
                                        \"fieldName\": \"location\",\
                                        \"trimmedChars\": \" ()\",\
                                        \"type\" : 0\
                                    },\
                                \"html body.toc p.nextpage font a\" :\
                                    {\
                                        \"fieldName\": \"titleNext\",\
                                        \"trimmedChars\": \" \",\
                                        \"type\" : 0,\
                                        \"attributes\" : {\
                                                \"href\": {\
                                                        \"fieldName\": \"linkNext\",\
                                                        \"trimmedChars\": \" \"\
                                                    }\
                                            }\
                                    }\
                                }";
    
    ParametrizedSAXParser* parser = [[ParametrizedSAXParser alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding ]
                                                                    encoding:NSUTF8StringEncoding
                                                                    dataMap:stringDataMap];
    NSDictionary* ads =(NSDictionary*)[parser parse];
    
    //NSLog(@"TEST DONE %@", ads);
    
    NSString *value;
    NSArray *data;
    NSDictionary *obj;
    
    //Title
    data = [ads objectForKey:@"listTitle"];
    STAssertTrue(1 == [data count], @"Expected one item but found %lu", [data count]);
    value = [data objectAtIndex:0];
    STAssertEqualObjects(value, @"Tue Sep 11", @"Wrong title %@", value);
    
    //Ads
    data = [ads objectForKey:@"ads"];
    STAssertTrue(2 == [data count], @"Expected two items but found %lu", [data count]);
    obj = [data objectAtIndex:0];
    value = [obj valueForKey:@"title"];
    STAssertEqualObjects(value, @"THE PLAYMATE BOOK", @"Wrong title %@", value);
    value = [obj valueForKey:@"link"];
    STAssertEqualObjects(value, @"http://losangeles.craigslist.org/sfv/bks/3253676408.html", @"Wrong link %@", value);
    value = [obj valueForKey:@"price"];
    STAssertEqualObjects(value, @"$30", @"Wrong price %@", value);
    value = [obj valueForKey:@"location"];
    STAssertEqualObjects(value, @"Studio City", @"Wrong location %@", value);
    
    obj = [data objectAtIndex:1];
    value = [obj valueForKey:@"title"];
    STAssertEqualObjects(value, @"BOOKS-BOOKS-BOOKS-BOOKS", @"Wrong title %@", value);
    value = [obj valueForKey:@"link"];
    STAssertEqualObjects(value, @"http://losangeles.craigslist.org/wst/bks/3229115844.html", @"Wrong link %@", value);
    value = [obj valueForKey:@"price"];
    STAssertEqualObjects(value, @"", @"Wrong price %@", value);
    value = [obj valueForKey:@"location"];
    STAssertEqualObjects(value, @"WEST LOS ANGELES", @"Wrong location %@", value);
    
    //Link to the next page
    data = [ads objectForKey:@"linkNext"];
    STAssertTrue(1 == [data count], @"Expected one item but found %lu", [data count]);
    value = [data objectAtIndex:0];
    STAssertEqualObjects(value, @"http://losangeles.craigslist.org/bka/index100.html", @"Wrong link %@", value);
    
    [parser release];
    [stringDataMap release];
}

- (void) testSimpleAdSearch {
    
    
    NSString* htmlString = [self.unitTestHelper contentsOfFile:@"SimpleBookSearch"];
    
    NSString *stringDataMap = @"{\"html body.toc p.row\" :\
                                    {\
                                        \"fieldName\": \"ads\",\
                                        \"type\" : 1\
                                    },\
                                \"html body.toc p.row a\" :\
                                    {\
                                        \"fieldName\": \"title\",\
                                        \"trimmedChars\": \" \",\
                                        \"type\" : 0,\
                                        \"attributes\" : {\
                                                \"href\": {\
                                                    \"fieldName\": \"link\",\
                                                    \"trimmedChars\": \" \"\
                                                    }\
                                            }\
                                    },\
                                \"html body.toc p.row span.itempp\" :\
                                    {\
                                        \"fieldName\": \"price\",\
                                        \"trimmedChars\": \" \",\
                                        \"type\" : 0\
                                    },\
                                \"html body.toc p.row span.itemdate\" :\
                                    {\
                                        \"fieldName\": \"date\",\
                                        \"trimmedChars\": \" \",\
                                        \"type\" : 0\
                                    },\
                                \"html body.toc p.row span.itempn\" :\
                                    {\
                                        \"fieldName\": \"location\",\
                                        \"trimmedChars\": \" ()\",\
                                        \"type\" : 0\
                                    },\
                                \"html body.toc h4.ban span a\" :\
                                    {\
                                        \"fieldName\": \"titleNext\",\
                                        \"trimmedChars\": \" \",\
                                        \"type\" : 0,\
                                        \"attributes\" : {\
                                            \"href\": {\
                                                \"fieldName\": \"linkNext\",\
                                                \"trimmedChars\": \" \"\
                                                }\
                                            }\
                                    }\
                                }";

    ParametrizedSAXParser* parser = [[ParametrizedSAXParser alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding ]
                                                                    encoding:NSUTF8StringEncoding
                                                                    dataMap:stringDataMap];
    NSDictionary* ads =(NSDictionary*)[parser parse];

    //NSLog(@"TEST DONE %@", ads);

    NSString *value;
    NSArray *data;
    NSDictionary *obj;
    
    //Ads
    data = [ads objectForKey:@"ads"];
    STAssertTrue(2 == [data count], @"Expected two items but found %lu", [data count]);
    obj = [data objectAtIndex:0];
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
    
    obj = [data objectAtIndex:1];
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
    data = [ads objectForKey:@"linkNext"];
    STAssertTrue(1 == [data count], @"Expected one item but found %lu", [data count]);
    value = [data objectAtIndex:0];
    STAssertEqualObjects(value, @"http://losangeles.craigslist.org/search/bka?query=book&srchType=A&s=100", @"Wrong link %@", value);

    [parser release];
    [stringDataMap release];
}


@end
