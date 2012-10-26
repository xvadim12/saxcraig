//
//  DataMapManager.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/16/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "AdResultsProcessor.h"
#import "AdListResultsProcessor.h"
#import "AdSearchResultsProcessor.h"
#import "DataMap.h"
#import "DataMapManager.h"
#import "DataMapLoader.h"

NSString* const DM_FILE_SINGLE = @"ad";
NSString* const DM_FILE_LIST = @"adlist";
NSString* const DM_FILE_SEARCH = @"adsearch";

NSString* const DM_FILE_EXT = @"json";

@interface DataMapManager ()

@property (nonatomic, retain) NSMutableArray* dataMaps;
@property (nonatomic, retain) NSArray* dataMapFiles;
@property (nonatomic, retain) DataMapLoader* dataMapLoader;

- (NSString*)versionOfDataMap:(DataMapType)dataMapType;

@end

@implementation DataMapManager

@synthesize dataMaps;
@synthesize dataMapFiles;
@synthesize dataMapLoader;

static DataMapManager* _sharedDMSingelton = nil;

+ (DataMapManager*)sharedMapManager {
    @synchronized([DataMapManager class])
	{
		if (!_sharedDMSingelton)
			_sharedDMSingelton = [[self alloc] init];
		return _sharedDMSingelton;
	}
    
	return nil;
}

- (id) init {
    if (self == [super init]) {
        self.dataMapFiles = [NSMutableArray arrayWithObjects:DM_FILE_SINGLE, DM_FILE_LIST, DM_FILE_SEARCH, nil];
        //self.dataMaps = [NSMutableArray arrayWithObjects:[NSNull null] count:[self.dataMapFiles count]];
        self.dataMaps = [[NSMutableArray alloc] init];
        for (NSUInteger i = [self.dataMapFiles count]; i > 0; i--) {
            [self.dataMaps addObject:[NSNull null]];
        }
        self.dataMapLoader = [[DataMapLoader alloc] init];
    }
    return self;
}

- (void) dealloc {
    
    self.dataMapFiles = nil;
    self.dataMaps = nil;
    self.dataMapLoader = nil;
    
    [super dealloc];
}

- (DataMap*)dataMapWithType:(DataMapType)dataMapType {
    if ([NSNull null] == [self.dataMaps objectAtIndex:dataMapType]) {
        [self.dataMaps replaceObjectAtIndex:dataMapType withObject:[self loadDataMapWithType:dataMapType]];
    }
    return [self.dataMaps objectAtIndex:dataMapType];
}

- (DataMap*)loadDataMapWithType:(DataMapType)dataMapType {
    NSError* err = nil;
    NSString* path = [[dataMapsDirectory() stringByAppendingPathComponent:[self.dataMapFiles objectAtIndex:dataMapType]]
                                           stringByAppendingPathExtension:DM_FILE_EXT];

    NSString* stringDataMap = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    DataMap* dm = nil;
    if (nil != stringDataMap) {
        dm = [[DataMap alloc] initWithString:stringDataMap encoding:NSUTF8StringEncoding];
        switch (dataMapType) {
            case DM_TYPE_SINGLE:
                dm.resultsProcessor = [[AdResultsProcessor alloc] init];
                break;
            case DM_TYPE_LIST:
                dm.resultsProcessor = [[AdListResultsProcessor alloc] init];
                break;
            case DM_TYPE_SEARCH:
                dm.resultsProcessor = [[AdSearchResultsProcessor alloc] init];
                break;
            default:
                break;
        }
    }
    return dm;
}

- (NSString*)versionOfDataMap:(DataMapType)dataMapType {
    DataMap* dm = [self loadDataMapWithType:dataMapType];
    NSString* v = dm ? dm.version : @"0";
    [dm release];
    return v;
}

- (BOOL) isUpdatingFinished {
    return [self.dataMapLoader isFinished];
}

- (void) startUpdateDataMapIfNeeded:(DataMapType)dataMapType {
    
    NSString* dmFile = [self.dataMapFiles objectAtIndex:dataMapType];
    
    NSString* dmFileName = [NSString stringWithFormat:@"%@.%@", dmFile, DM_FILE_EXT];
    if (! [self.dataMapLoader isActualVersion:[self versionOfDataMap:dataMapType] ofDataMapFile:dmFileName]) {
        [self.dataMapLoader startLoadDataMapFile:dmFileName];
    }
}

@end
