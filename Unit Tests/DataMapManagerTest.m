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
    return;
    NSString* path = @"html body.posting h2";
    DataMap* dataMap = [[DataMapManager sharedMapManager] dataMapWithType:DM_TYPE_SINGLE];
    STAssertTrue(13 == [[dataMap.tokenizedPaths allKeys] count], @"Wrong count of keys %lu", [[dataMap.tokenizedPaths allKeys] count]);
    STAssertNotNil(dataMap.resultsProcessor, @"Results processor is nil");
    STAssertEqualObjects([AdResultsProcessor class], [dataMap.resultsProcessor class], @"Wrong class %@", [dataMap.resultsProcessor class]);
    
    NSDictionary* d = [dataMap dataMapInfoForPath:path];
    STAssertNotNil(d, @"Data map info is Nil");
}

- (void)testGetDataMapSingle2 {
    return;
    NSString* path = @"html body.posting h2";
    DataMap* dataMap = [[DataMapManager sharedMapManager] dataMapWithType:DM_TYPE_SINGLE];
    STAssertTrue(13 == [[dataMap.tokenizedPaths allKeys] count], @"Wrong count of keys %lu", [[dataMap.tokenizedPaths allKeys] count]);
    STAssertNotNil(dataMap.resultsProcessor, @"Results processor is nil");
    STAssertEqualObjects([AdResultsProcessor class], [dataMap.resultsProcessor class], @"Wrong class %@", [dataMap.resultsProcessor class]);
    
    NSDictionary* d = [dataMap dataMapInfoForPath:path];
    STAssertNotNil(d, @"Data map info is Nil");
}


- (void)testGetDataMapList {
    return;
    DataMap* dataMap = [[DataMapManager sharedMapManager] dataMapWithType:DM_TYPE_LIST];
    STAssertTrue(14 == [[dataMap.tokenizedPaths allKeys] count], @"Wrong count of keys %lu", [[dataMap.tokenizedPaths allKeys] count]);
    STAssertNotNil(dataMap.resultsProcessor, @"Results processor is nil");
    STAssertEqualObjects([AdListResultsProcessor class], [dataMap.resultsProcessor class], @"Wrong class %@", [dataMap.resultsProcessor class]);
}


- (void)testGetDataMapSearch {
    return;
    DataMap* dataMap = [[DataMapManager sharedMapManager] dataMapWithType:DM_TYPE_SEARCH];
    STAssertTrue(19 == [[dataMap.tokenizedPaths allKeys] count], @"Wrong count of keys %lu", [[dataMap.tokenizedPaths allKeys] count]);
    STAssertNotNil(dataMap.resultsProcessor, @"Results processor is nil");
    STAssertEqualObjects([AdSearchResultsProcessor class], [dataMap.resultsProcessor class], @"Wrong class %@", [dataMap.resultsProcessor class]);
}

- (void)testUpdateIfAbsent {
    //return;
    DataMapManager* dmManager = [DataMapManager sharedMapManager];
    DataMapType dmTypes[] = {DM_TYPE_SINGLE, DM_TYPE_LIST, DM_TYPE_SEARCH};
    for(int i = 0; i < 3; i++) {
        [dmManager startUpdateDataMapIfNeeded:dmTypes[i]];
        
        while (![dmManager isUpdatingFinished]) {
            sleep(1);
        }
    }
    
    NSArray* files = [NSArray arrayWithObjects:@"ad.json", @"adlist.json", @"adsearch.json", nil];
    NSString* dmPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    for(NSString* file in files) {
        NSString* targetFile = [dmPath stringByAppendingPathComponent:file];
        STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:targetFile], @"File %@ does not exits", targetFile);
        [[NSFileManager defaultManager] removeItemAtPath: targetFile error: nil];
    }
}

@end
