//
//  ParametrizedSAXParser.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/19/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#define CLASS_ATTR @"class"

//Keys for data map
#define kFieldName @"fieldName"
#define kTrimmedChars @"trimmedChars"
#define kObjectType @"type"

#define kScalarObject 0
#define kDictObject 1


#import "ParametrizedSAXParser.h"

/**
 Simple stack for saving current path in the file
 */
@interface NSMutableArray (PathStack)
- (void) push: (id)item;
- (void) pop;
@end

@implementation NSMutableArray (PathStack)
- (void) push: (id)item {
    [self addObject:item];
}

- (void) pop {
    if ([self count] != 0) {
        [self removeLastObject];
    }
}
@end

@interface NSString (StringWithTrim)
- (NSString*)trimChars:(NSString*)trimmedChars;
@end

@implementation NSString (StringWithTrim)
- (NSString*)trimChars:(NSString*)trimmedChars {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:trimmedChars]];
}
@end


@implementation ParametrizedSAXParser {
    
    DTHTMLParser* _htmlParser;
    
    NSDictionary *_dataMap;
    
    NSMutableArray* _pathStack;
    
    /**
     String for accumulating current char data
     */
    NSMutableString* _dataString;
    
    /**
     Dict for accumulating data of current parsed object
     */
    NSMutableDictionary* _parsedObject;
    
    NSMutableDictionary* _resultDictionary;
}


- (id) initWithData:(NSData *)data encoding:(NSStringEncoding)encoding dataMap:(NSString*)stringDataMap {
    if (self = [super init]) {
        _htmlParser = [[DTHTMLParser alloc] initWithData:data encoding:encoding];
        _htmlParser.delegate = self;
        
        _dataMap = [self parseMapData:stringDataMap encoding:encoding];
        
        _pathStack = [NSMutableArray array];
        
        _dataString = [[NSMutableString alloc] init];
        _parsedObject = nil;
        
        _resultDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void) dealloc {
    
    [_htmlParser release];
	_htmlParser = nil;
    
    _dataMap = nil;    
    _pathStack = nil;    
    _dataString = nil;
    _parsedObject = nil;
    _resultDictionary = nil;
    
	[super dealloc];
}

/**
 Parses string representation of map data.
 @return dictionary with mat data
 */
- (NSDictionary*)parseMapData:(NSString*)stringMapData encoding:(NSStringEncoding)encoding{
    
    NSError *error;
    //TODO: error processing; check that all needed keys are present
    return [NSJSONSerialization JSONObjectWithData:[stringMapData dataUsingEncoding:encoding] options:kNilOptions error:&error];
}

/**
 Build string representation of current path from current state of path stack
 */
- (NSString*) stringPath {
    
    NSMutableString *strPath = [NSMutableString stringWithString:@""];
    for(NSString *subPath in _pathStack)
        [strPath appendFormat:@" %@", subPath];
    return [strPath substringFromIndex:1];
}

- (NSObject*)buildResult {
    return [NSNull null];
}

- (NSObject*) parse {
    
    [_htmlParser parse];

    return _resultDictionary;
}

- (void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    NSString *elementClass = [attributeDict valueForKey:CLASS_ATTR];
    
    NSString *subPath; 
    if (nil != elementClass)
        subPath = [NSString stringWithFormat:@"%@.%@", elementName, elementClass];
    else
        subPath = [NSString stringWithString:elementName];
    
    [_pathStack push:subPath];
    
    NSString *strPath = [self stringPath];
    NSDictionary *dataInfoDict = [_dataMap valueForKey:strPath];
    if (nil != dataInfoDict)
    {
        //NSLog(@"START %@", strPath);
        if ([[dataInfoDict valueForKey:kObjectType] intValue] == kScalarObject)
            [_dataString setString:@""];
        else
            _parsedObject = [[NSMutableDictionary alloc] init];
    }
}

- (void)parser:(DTHTMLParser *)parser foundCharacters:(NSString *)string {
    [_dataString appendString:string];
}

- (void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    
    NSString *strPath = [self stringPath];
    
    NSDictionary *dataInfoDict = [_dataMap valueForKey:strPath];
    if (nil != dataInfoDict)
    {
        NSString *fieldName = [dataInfoDict valueForKey:kFieldName];        
        int objType = [[dataInfoDict valueForKey:kObjectType] intValue];
        NSMutableArray *dataArray;
        
        //create a new key in results only for objects or scalars of first level
        if ((nil == _parsedObject && objType == kScalarObject) || objType == kDictObject)
        {
            //assume that all objects are arrays (for more simple parser)
            //some objects like ad list title will be presented by array with one item
            dataArray = (NSMutableArray*)[_resultDictionary valueForKey:fieldName];
            if (nil == dataArray) {
                dataArray = [NSMutableArray array];
                [_resultDictionary setValue:dataArray forKey:fieldName];
            }
        }
        //... and add a new value
        if (objType == kScalarObject)
        {
            if (nil == _parsedObject)
                [dataArray addObject:[_dataString trimChars:[dataInfoDict valueForKey:kTrimmedChars]]];
            else
                [_parsedObject setValue:[_dataString trimChars:[dataInfoDict valueForKey:kTrimmedChars]] forKey:fieldName];
        }
        else
        {
            [dataArray addObject: _parsedObject];
            [_parsedObject release];
            _parsedObject = nil;
        }
    }
    
    [_pathStack pop];
}

@end


