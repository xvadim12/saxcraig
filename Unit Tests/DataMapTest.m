//
//  DataMapTest.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/15/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "UnitTestHelper.h"
#import "DataMap.h"
#import "PathItem.h"

#import "DataMapTest.h"

@implementation DataMapTest

- (void) pathItemTesting:(PathItem*)item tagName:(NSString*)tagName elName:(NSString*)elName elID:(NSString*)elID elClass:(NSString*)elClass {
    STAssertEqualObjects(tagName, item.elementTagName, @"Wrong tag name %@", item.elementTagName);
    STAssertEqualObjects(elName, item.elementName, @"Wrong tag element name %@", item.elementName);
    STAssertEqualObjects(elID, item.elementID, @"Wrong tag id %@", item.elementID);
    STAssertEqualObjects(elClass, item.elementClass, @"Wrong tag class %@", item.elementClass);
}

- (void) testLoadSimpleDataMap {
    //return;
    NSString* stringDataMap = [self.unitTestHelper contentsOfFile:@"simpledatamap" withType:@"json"];
    DataMap* dataMap = [[[DataMap alloc] initWithString:stringDataMap encoding:NSUTF8StringEncoding] autorelease];
    STAssertEqualObjects(@"1", dataMap.version, @"Wrong version %@", dataMap.version);
    STAssertTrue(7 == [[dataMap.tokenizedPaths allKeys] count], @"Wrong count of keys %lu", [[dataMap.tokenizedPaths allKeys] count]);
    
    NSDictionary* dict1 = [dataMap dataMapInfoForPath:@"path1"];
    NSDictionary* dict2 = [dataMap dataMapInfoForPath:@"path2"];
    STAssertEqualObjects(dict1, dict2, @"The dicts should be equal");
    
    NSArray* tPath = [dataMap.tokenizedPaths objectForKey:@"path3.class"];
    STAssertTrue(1 == [tPath count], @"Wrong path len", [tPath count]);
    PathItem* pItem = [tPath objectAtIndex:0];
    [self pathItemTesting:pItem tagName:@"path3" elName:nil elID:nil elClass:@"class"];
    
    tPath = [dataMap.tokenizedPaths objectForKey:@"path4#id"];
    STAssertTrue(1 == [tPath count], @"Wrong path len", [tPath count]);
    pItem = [tPath objectAtIndex:0];
    [self pathItemTesting:pItem tagName:@"path4" elName:nil elID:@"id" elClass:nil];
    
    tPath = [dataMap.tokenizedPaths objectForKey:@"path5[name]"];
    STAssertTrue(1 == [tPath count], @"Wrong path len", [tPath count]);
    pItem = [tPath objectAtIndex:0];
    [self pathItemTesting:pItem tagName:@"path5" elName:@"name" elID:nil elClass:nil];
    
    NSString* bigPath = @"html body.posting div#userbody";
    
    tPath = [dataMap.tokenizedPaths objectForKey:bigPath];
    STAssertTrue(3 == [tPath count], @"Wrong path len", [tPath count]);
    
    dict1 = [dataMap dataMapInfoForPath:bigPath];
    NSUInteger allKeysCount = [[dict1 allKeys] count];
    STAssertTrue(3 == allKeysCount, @"Wrong count of keys in dict %lu", allKeysCount);
}

- (void) testLoadAdDataMap {
    //return;
    NSString* stringDataMap = [self.unitTestHelper contentsOfFile:@"ad" withType:@"json"];
    DataMap* dataMap = [[[DataMap alloc] initWithString:stringDataMap encoding:NSUTF8StringEncoding] autorelease];
    STAssertTrue(13 == [[dataMap.tokenizedPaths allKeys] count], @"Wrong count of keys %lu", [[dataMap.tokenizedPaths allKeys] count]);
}

- (void) testLoadAdListDataMap {
    //return;
    NSString* stringDataMap = [self.unitTestHelper contentsOfFile:@"adlist" withType:@"json"];
    DataMap* dataMap = [[[DataMap alloc] initWithString:stringDataMap encoding:NSUTF8StringEncoding] autorelease];
    STAssertTrue(14 == [[dataMap.tokenizedPaths allKeys] count], @"Wrong count of keys %lu", [[dataMap.tokenizedPaths allKeys] count]);
}

- (void) testLoadAdSearchDataMap {
    //return;
    NSString* stringDataMap = [self.unitTestHelper contentsOfFile:@"adsearch" withType:@"json"];
    DataMap* dataMap = [[[DataMap alloc] initWithString:stringDataMap encoding:NSUTF8StringEncoding] autorelease];
    STAssertTrue(19 == [[dataMap.tokenizedPaths allKeys] count], @"Wrong count of keys %lu", [[dataMap.tokenizedPaths allKeys] count]);
}

@end
