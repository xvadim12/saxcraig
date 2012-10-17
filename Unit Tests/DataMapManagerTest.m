//
//  DataMapManagerTest.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/16/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "AdResultsProcessor.h"
#import "AdListResultsProcessor.h"
#import "AdSearchResultsProcessor.h"
#import "DataMapManager.h"
#import "DataMap.h"
#import "DataMapManagerTest.h"

@implementation DataMapManagerTest

- (void)testGetDataMapSingle {
    NSString* path = @"html body.posting h2";
    DataMap* dataMap = [[DataMapManager sharedMapManager] dataMapWithType:DM_TYPE_SINGLE];
    STAssertTrue(13 == [[dataMap.tokenizedPaths allKeys] count], @"Wrong count of keys %lu", [[dataMap.tokenizedPaths allKeys] count]);
    STAssertNotNil(dataMap.resultsProcessor, @"Results processor is nil");
    STAssertEqualObjects([AdResultsProcessor class], [dataMap.resultsProcessor class], @"Wrong class %@", [dataMap.resultsProcessor class]);
    
    NSDictionary* d = [dataMap dataMapInfoForPath:path];
    STAssertNotNil(d, @"Data map info is Nil");
}

- (void)testGetDataMapSingle2 {
    NSString* path = @"html body.posting h2";
    DataMap* dataMap = [[DataMapManager sharedMapManager] dataMapWithType:DM_TYPE_SINGLE];
    STAssertTrue(13 == [[dataMap.tokenizedPaths allKeys] count], @"Wrong count of keys %lu", [[dataMap.tokenizedPaths allKeys] count]);
    STAssertNotNil(dataMap.resultsProcessor, @"Results processor is nil");
    STAssertEqualObjects([AdResultsProcessor class], [dataMap.resultsProcessor class], @"Wrong class %@", [dataMap.resultsProcessor class]);
    
    NSDictionary* d = [dataMap dataMapInfoForPath:path];
    STAssertNotNil(d, @"Data map info is Nil");
}


- (void)testGetDataMapList {
    //return;
    DataMap* dataMap = [[DataMapManager sharedMapManager] dataMapWithType:DM_TYPE_LIST];
    STAssertTrue(14 == [[dataMap.tokenizedPaths allKeys] count], @"Wrong count of keys %lu", [[dataMap.tokenizedPaths allKeys] count]);
    STAssertNotNil(dataMap.resultsProcessor, @"Results processor is nil");
    STAssertEqualObjects([AdListResultsProcessor class], [dataMap.resultsProcessor class], @"Wrong class %@", [dataMap.resultsProcessor class]);
}


- (void)testGetDataMapSearch {
    //return;
    DataMap* dataMap = [[DataMapManager sharedMapManager] dataMapWithType:DM_TYPE_SEARCH];
    STAssertTrue(19 == [[dataMap.tokenizedPaths allKeys] count], @"Wrong count of keys %lu", [[dataMap.tokenizedPaths allKeys] count]);
    STAssertNotNil(dataMap.resultsProcessor, @"Results processor is nil");
    STAssertEqualObjects([AdSearchResultsProcessor class], [dataMap.resultsProcessor class], @"Wrong class %@", [dataMap.resultsProcessor class]);
}

@end
