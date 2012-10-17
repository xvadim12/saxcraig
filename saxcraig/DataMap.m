//
//  DataMap.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/15/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "JSONKit.h"

#import "PathItem.h"
#import "ResultsProcessor.h"
#import "DataMap.h"

//Global keys for data map

NSString* const kMeta = @"meta";
NSString* const kVesrion = @"version";
NSString* const kPathsMap = @"pathsmap";

//Keys for data map in paths sections
NSString* const kFieldName = @"fieldName";
NSString* const kTrimmedChars = @"trimmedChars";
NSString* const kObjectType = @"type";
NSString* const kAttributesKey = @"attributes";
NSString* const kUnparsedRegExpsKey = @"regexps";
NSString* const kRefPath = @"ref";
NSString* const kUnusedFieldName = @"unused";

NSString* const kScalarObject = @"Scalar";
NSString* const kDictObject   = @"Dict";

//Keys in result subdictionaries
NSString* const kDataKey = @"data";
NSString* const kFieldNameKey = @"fieldName";

@interface DataMap()

@property (nonatomic, retain) NSDictionary* dataMap;

- (NSDictionary*)parseDataMap:(NSString*)stringMapData encoding:(NSStringEncoding)encoding;
- (NSDictionary*)buildTokenizedPaths:(NSDictionary*)dMap;

@end

@implementation DataMap

@synthesize tokenizedPaths;
@synthesize version;
@synthesize resultsProcessor;

- (id)initWithString:(NSString*)stringMapData encoding:(NSStringEncoding)encoding {
    if (self = [super init]) {
        self.dataMap = [self parseDataMap:stringMapData encoding:encoding];
        self.tokenizedPaths = [self buildTokenizedPaths:self.dataMap];
    }
    return self;
}

- (void) dealloc {
    
    self.dataMap = nil;
    
    self.tokenizedPaths = nil;
    self.version = nil;
    self.resultsProcessor = nil;
    
	[super dealloc];
}

- (NSDictionary*)dataMapInfoForPath:(NSString *)path {
    NSDictionary* dataMapInfo = [self.dataMap objectForKey:path];
    if ([[dataMapInfo allKeys] containsObject:kRefPath]) {
        NSString* origPath = [dataMapInfo objectForKey:kRefPath];
        dataMapInfo = [self.dataMap objectForKey:origPath];
    }
    return dataMapInfo;
}

- (NSDictionary*)parseDataMap:(NSString*)stringMapData encoding:(NSStringEncoding)encoding{
    
    NSError *error;
    //TODO: error processing; check that all needed keys are present
    NSDictionary* dMap = [[stringMapData dataUsingEncoding:encoding] objectFromJSONDataWithParseOptions:0 error:&error];
    NSDictionary* meta = [NSDictionary dictionaryWithDictionary:[dMap objectForKey:kMeta]];
    self.version = [NSString stringWithString:[meta objectForKey:kVesrion]];
    return [NSDictionary dictionaryWithDictionary:[dMap objectForKey:kPathsMap]];
}

/**
 Builds tokenized version of pathes in the data map
 Returns dict:
 stringPath: NSArray of path's tokens
 */
- (NSDictionary*)buildTokenizedPaths:(NSDictionary*)dMap {
    
    NSMutableDictionary* piDMap = [[NSMutableDictionary alloc] init];
    for(NSString* strPath in [dMap allKeys]) {
        NSArray* pathItems = [strPath componentsSeparatedByString:@" "];
        NSMutableArray* pathArray = [NSMutableArray array];
        for(NSString* item in pathItems)
            [pathArray addObject:[[PathItem alloc] initItemFromString:item]];
        [piDMap setObject:pathArray forKey:strPath];
    }
    return piDMap;
}

@end
