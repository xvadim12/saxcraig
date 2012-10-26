//
//  SAXParserTest.m
//  saxcraig
//
//  Created by Vadim A. Khohlov on 9/12/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "DataMapLoader.h"

#import "SAXParserTest.h"
#import "UnitTestHelper.h"

@implementation SAXParserTest

@synthesize unitTestHelper;

- (void) dealloc {
	self.unitTestHelper = nil;
    self.dataMapFiles = nil;
    self.dataMapDir = nil;
    
	[super dealloc];
}

- (void) setUp {
    
	if (nil==self.unitTestHelper) {
		self.unitTestHelper = [[[UnitTestHelper alloc] init] autorelease];
	}
    
    //copy data maps from resources to directory
    self.dataMapFiles = [NSArray arrayWithObjects:@"ad", @"adlist", @"adsearch", nil];
    self.dataMapDir = dataMapsDirectory();
    
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    for (NSString* file in self.dataMapFiles) {
        NSString* path = [bundle pathForResource:file ofType:@"json"];
        NSString* dmFullFile = [[self.dataMapDir stringByAppendingPathComponent:file] stringByAppendingPathExtension:@"json"];
        [filemgr copyItemAtPath:path toPath:dmFullFile error:nil];
    }
	
}

- (void)tearDown {
    [self removeDataMaps];
    
    [super tearDown];
}

- (void)removeDataMaps {
    NSArray* files = [NSArray arrayWithObjects:@"ad.json", @"adlist.json", @"adsearch.json", nil];
    NSString* dmPath = dataMapsDirectory();
    for(NSString* file in files) {
        NSString* targetFile = [dmPath stringByAppendingPathComponent:file];
        [[NSFileManager defaultManager] removeItemAtPath: targetFile error: nil];
    }
}

@end
