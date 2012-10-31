//
//  ParametrizedSAXParser.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/19/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "ParametrizedSAXParser.h"
#import "NSString+StringWithTrim.h"
#import "Stack.h"
#import "PathStack.h"
#import "PathItem.h"
#import "PathItemEx.h"
#import "DataMap.h"
#import "ResultsProcessor.h"

NSString* const TAG_HTML = @"html";

@implementation ParametrizedSAXParser {
    
    DTHTMLParser* _htmlParser;
    
    /**
     Stack for saving data for not finished tag
     */
    Stack* _dataStack;
    
    PathStack* _pathStack;
    
    /**
     String for accumulating current char data
     */
    NSMutableString* _dataString;
    
    /**
     Dict for accumulating data of current parsed object
     */
    NSMutableDictionary* _parsedObject;
    
    NSMutableArray* _resultObject;
}

@synthesize dataMap;

- (id) initWithType:(DataMapType)dataMapType {
    
    if (self = [super init]) {
        
        _dataStack = [[Stack alloc] init];
        _pathStack = [[PathStack alloc] init];
        
        _dataString = [[NSMutableString alloc] init];
        _parsedObject = nil;
        
        _resultObject = [NSMutableArray array];
        
        self.dataMap = [[DataMapManager sharedMapManager] dataMapWithType:dataMapType];
    }
    
    return self;
}

- (void) dealloc {
    
    [_pathStack release];
    _pathStack = nil;    
    [_dataStack release];
    _dataStack = nil;
    
    _dataString = nil;
    [_parsedObject release];
    _parsedObject = nil;
    
    self.dataMap = nil;
    
	[super dealloc];
}

- (NSObject*) parseHtmlString:(NSString*)htmlString{
    [self parse:htmlString];
    ResultsProcessor* rp = self.dataMap.resultsProcessor;
    return [rp parseResultArray:_resultObject];
}

- (NSArray*) parse:(NSString*)htmlString{
    
    _htmlParser = [[DTHTMLParser alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
    _htmlParser.delegate = self;
    
    [_dataStack clear];
    [_pathStack clear];
    [_resultObject removeAllObjects];
    [_dataString setString:@""];
    
    _parsedObject = nil;
    
    [_htmlParser parse];
    
    [_htmlParser release];
	_htmlParser = nil;
    
    return _resultObject;
}

- (void) parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:TAG_HTML])
        return;

    PathItemEx* pathItem = [[PathItemEx alloc] initItem:elementName withAttributes:attributeDict];
    [_pathStack push:pathItem];

    NSString* strPath = [_pathStack findMatchingPathInArray: self.dataMap.tokenizedPaths];
    if (nil != strPath)
    {
        [_pathStack setMatchedPath:strPath];
        NSDictionary *dataInfoDict = [self.dataMap dataMapInfoForPath:strPath];
        if ([[dataInfoDict objectForKey:kObjectType] isEqualToString: kScalarObject])
        {
            /*
             If processing of current tag is not finished, save currently accummulated data. For example, for fragment:
             
             <div id="userbody">
                 i-phone text ...
                 <br>
                 <ul class="blurbs">
                     <li> Location: &#1082;&#1080;&#1077;&#1074;</li>
                     <li>it's NOT ok to contact this poster with services or other commercial interests</li>
                 </ul>
             </div>
             
             we should save data ('i-phone text ...') begore starting of processing <li> tag. Saved data will be added to result in processing </div>
             */
            if (![_dataString isEqualToString:@""])
                [_dataStack push: [NSString stringWithString:_dataString]];
        }
        else
            _parsedObject = [[NSMutableDictionary alloc] init];
        
        [_dataString setString:@""];
        
        NSDictionary *subDataMap = [dataInfoDict objectForKey:kAttributesKey];
        if (nil != subDataMap)
            [self parseAttributes:attributeDict withDataMap:subDataMap];
    }
}

- (void) parseAttributes:(NSDictionary *)attributeDict withDataMap:(NSDictionary*)subDataMap {
    [subDataMap enumerateKeysAndObjectsUsingBlock:^(id key, id dataInfoDict, BOOL *stop) {
        NSString *attrValue = [attributeDict objectForKey:key];
        if (nil != attrValue)
        {
            //assume that tag's attributes contain only scalar objects
            [self saveScalarObject:attrValue withFieldName:[dataInfoDict objectForKey:kFieldName] andDataInfo:dataInfoDict];
            //may be we can extract some info from data by regexp
            [self parseUnparsed:attrValue withDataInfo:dataInfoDict];
        }
    }];
}

- (void) parser:(DTHTMLParser *)parser foundCharacters:(NSString *)string {
    [_dataString appendString:string];
}

- (void) parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    
    if ([elementName isEqualToString:TAG_HTML])
        return;
    
    NSString* strPath = [_pathStack currentMatchedPath];
    if (nil != strPath)
    {
        NSDictionary *dataInfoDict = [self.dataMap dataMapInfoForPath:strPath];
        NSString *fieldName = [dataInfoDict objectForKey:kFieldName];
        NSString *objType = [dataInfoDict objectForKey:kObjectType];

        //may be we can extract some info from data by regexp
        [self parseUnparsed:_dataString withDataInfo:dataInfoDict];
        
        //... and add a new value
        if ([objType isEqualToString: kScalarObject])
        {
            [self saveScalarObject:_dataString withFieldName:fieldName andDataInfo:dataInfoDict];
            NSString* prevData = [_dataStack pop];
            if (nil == prevData)
                [_dataString setString: @""];
            else
                [_dataString setString:prevData];
        }
        else
        {
            if (nil != fieldName)
                [_resultObject addObject:[NSDictionary dictionaryWithObjectsAndKeys:fieldName, kFieldNameKey, _parsedObject, kDataKey, nil]];
            [_parsedObject release];
            _parsedObject = nil;
        }
    }
    
    [_pathStack pop];
}

/**
 Saves scalar object to _resultObject or to _parsedObject dictionary
 */
-(void)saveScalarObject:(NSString*)value withFieldName:(NSString*)fieldName andDataInfo:(NSDictionary*)dataInfoDict {
    if (nil != fieldName) {
        NSString* trimmedValue = [value trimChars:[dataInfoDict objectForKey:kTrimmedChars]];
        if (nil == _parsedObject)
        {
            [_resultObject addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                            fieldName, kFieldNameKey, trimmedValue, kDataKey, nil]];
        }
        else
            [_parsedObject setValue:trimmedValue forKey:fieldName];
    }
}

- (void) parseUnparsed:(NSString*)unparsed withDataInfo:(NSDictionary*)dataInfoDict {

    NSDictionary* regexps = [dataInfoDict objectForKey:kUnparsedRegExpsKey];
    if (nil != regexps) {
        NSArray* objectFields = [_parsedObject allKeys];
        for(NSString* fieldName in [regexps allKeys]) {
            //parseUnparsed called as last chance to  extract some information
            //so, if we parse object and it already contains data don't override it from unparsed section
            if (nil == _parsedObject || ![objectFields containsObject:fieldName]) {
                NSString* value = [self getDataFromString:unparsed byRegexp:[regexps objectForKey:fieldName] andTrimmedChars:nil];
                if (nil != value)
                    [self saveScalarObject:value withFieldName:fieldName andDataInfo:nil];
            }
        }
    }
}

- (NSString*) getDataFromString:(NSString*) stringData byRegexp:(NSObject*)regexp andTrimmedChars:(NSString*)trimmedChars {
    NSString* value = nil;
    NSError* error = NULL;
    NSArray* regexpsArray = nil;
    
    if ([regexp isKindOfClass:[NSString class]])
        regexpsArray = [NSArray arrayWithObject:regexp];
    else
        regexpsArray = (NSArray*)regexp;
    
    for(NSString* regexpString in regexpsArray) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexpString
                                                                               options:0
                                                                                 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:stringData options:0 range:NSMakeRange(0, [stringData length])];
        if (match.numberOfRanges > 0)
        {
            NSRange range = match.numberOfRanges > 1 ? [match rangeAtIndex:1] : match.range;
            value = [[stringData substringWithRange:range] trimChars:trimmedChars];
            break;
        }
    }
    return value;
}
@end


