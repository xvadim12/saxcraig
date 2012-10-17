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

NSString* const DM_FILE_SINGLE = @"ad";
NSString* const DM_FILE_LIST = @"adlist";
NSString* const DM_FILE_SEARCH = @"adsearch";

@interface DataMapManager ()

@property (nonatomic, retain) NSMutableArray* dataMaps;
@property (nonatomic, retain) NSArray* dataMapFiles;

@end

@implementation DataMapManager

@synthesize dataMaps;
@synthesize dataMapFiles;

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
    }
    return self;
}

- (void) dealloc {
    
    self.dataMapFiles = nil;
    self.dataMaps = nil;
    
    [super dealloc];
}

- (DataMap*)dataMapWithType:(DataMapType)dataMapType {
    if ([NSNull null] == [self.dataMaps objectAtIndex:dataMapType]) {
        [self.dataMaps replaceObjectAtIndex:dataMapType withObject:[self loadDataMapWithType:dataMapType]];
    }
    return [self.dataMaps objectAtIndex:dataMapType];
}

- (DataMap*)loadDataMapWithType:(DataMapType)dataMapType {
    //temporary
    //TODO: rewrite to correct paths to files
    NSError* err = nil;
	NSBundle* bundle = [NSBundle bundleForClass:[self class]];
	NSString* path = [bundle pathForResource:[self.dataMapFiles objectAtIndex:dataMapType] ofType:@"json"];
    
    NSString* stringDataMap = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    DataMap* dm = [[DataMap alloc] initWithString:stringDataMap encoding:NSUTF8StringEncoding];
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
    return dm;
}

@end
