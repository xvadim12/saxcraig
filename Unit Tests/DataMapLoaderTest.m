//
//  DataMapLoaderTest.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/17/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "DataMapLoaderTest.h"
#import "AFHTTPRequestOperation.h"
#import "DataMapLoader.h"

@implementation DataMapLoaderTest

- (void) testLoad {
    //return;
    DataMapLoader* loader = [[[DataMapLoader alloc] init] autorelease];
    
    STAssertTrue([loader isFinished], @"Loader should be finished by default");
    
    NSArray* files = [NSArray arrayWithObjects:@"ad.json", @"adlist.json", @"adsearch.json", nil];
    for(NSString* file in files) {

        NSString* targetFile = [loader.dataMapsDir stringByAppendingPathComponent:file];
        [[NSFileManager defaultManager] removeItemAtPath: targetFile error: nil];
        
        [loader startLoadDataMapFile:file];
        
        while (![loader isFinished]) {
            sleep(1);
        }
        
        STAssertNil(loader.lastError, @"Unexpected error %@", loader.lastError);
        STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:targetFile], @"File %@ does not exits", targetFile);
        [[NSFileManager defaultManager] removeItemAtPath: targetFile error: nil];
    }
}

- (void) testLoadNotFound {
    //return;
    DataMapLoader* loader = [[[DataMapLoader alloc] init] autorelease];
    
    STAssertTrue([loader isFinished], @"Loader should be finished by default");
    
    NSString* dataMapFile = @"absent.json";
    NSString* targetFile = [loader.dataMapsDir stringByAppendingPathComponent:dataMapFile];
    [[NSFileManager defaultManager] removeItemAtPath: targetFile error: nil];
    
    [loader startLoadDataMapFile:dataMapFile];
    
    while (![loader isFinished]) {
        sleep(1);
    }
    
    STAssertNotNil(loader.lastError, @"Unexpected error %@", loader.lastError);
    STAssertTrue(-1011 == loader.lastError.code, @"Wrong error %@", loader.lastError.code);
}

- (void)testVersionChecking {
    //return;
    DataMapLoader* loader = [[[DataMapLoader alloc] init] autorelease];
    NSString* dataMapFile = @"ad.json";
    BOOL b = [loader isActualVersion:@"0" ofDataMapFile:dataMapFile];
    STAssertFalse(b, @"Version should be expired");
    
    b = [loader isActualVersion:@"10000" ofDataMapFile:dataMapFile];
    STAssertTrue(b, @"Version should be actual");
}

@end
