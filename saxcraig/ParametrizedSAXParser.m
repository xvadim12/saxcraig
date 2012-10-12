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

//Keys for data map
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

@implementation ParametrizedSAXParser {
    
    DTHTMLParser* _htmlParser;
    
    NSDictionary* _dataMap;
    NSDictionary* _tokenizedPaths;
    
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

- (id) initWithDataMap:(NSString*)stringDataMap {
    
    if (self = [super init]) {
        
        _dataStack = [[Stack alloc] init];
        _pathStack = [[PathStack alloc] init];
        
        _dataString = [[NSMutableString alloc] init];
        _parsedObject = nil;
        
        _resultObject = [NSMutableArray array];
        
        _dataMap = [self parseDataMap:stringDataMap encoding:NSUTF8StringEncoding];
        _tokenizedPaths = [self buildTokenizedPaths:_dataMap];
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

    _dataMap = nil;
    [_tokenizedPaths release];
    _tokenizedPaths = nil;
    
	[super dealloc];
}

/**
 Parses string representation of map data.
 
 Next structure is expected:
 
 {
    path_to_object1 : { - dict with information about object
                        'fieldName': name of field in result dict,
                        'trimmedChars': string with chars which will be trimmed from start and end of value
                        'type': type of object - 'Scalar' for scalar, 'Dict' for dict, i.e. nested object
 
                        'attributes': { - subdictionary with information about html atg's attributes which whould be added to result
 
                                        'attributeName1': dict with keys 'fieldName, trimmedChars (only scalar object in attributes are supported,
                                        'attribiteName2': ...
                                      }
                     },
 
   path_to_object2 : {
                        ...
                     }
 }
 
 For example, for page:
 
 http://losangeles.craigslist.org/bka/
 
 
 with content (fragment):
 
 <body class="toc">
 
     <h4 class="ban">    Tue Sep 11</h4>
 
     <p class="row" data-latitude="" data-longitude="">
         <span class="ih" id="images:5I15Hd5Jb3Ld3I63Jec96234d7c389377190b.jpg">&nbsp;</span>
         <span class="itemdate"></span>
         <a href="http://losangeles.craigslist.org/sfv/bks/3253676408.html">THE PLAYMATE BOOK</a>
         <span class="itemsep"> - </span>
         <span class="itemph"></span>
         <span class="itempp"> $30</span>
         <span class="itempn"><font size="-1"> (Studio City)</font></span>
         <span class="itempx"> <span class="p"> pic</span></span>
         <span class="itemcg" title="bks"> <small class="gc"><a href="http://losangeles.craigslist.org/bks/">books &amp; magazines - by owner</a></small></span><br class="c">
     </p>
 
 A data map will be:
 
 {
    "html body.toc h4.ban" :
             {
                 "fieldName": "listTitle",
                 "trimmedChars": " ",
                 "type" : "Scalar"
             },
    "html body.toc p.row" :
             {
                "fieldName": "ads",
                "type" : "Dict"
             },
    "html body.toc p.row a" :
             {
                 "fieldName": "title",
                 "trimmedChars": " ",
                 "type" : "Scalar",
                 "attributes" : {
                     "href": {
                            "fieldName": "link",
                            "trimmedChars": " "
                         }
                     }
             },
    "html body.toc p.row span.itempp" :
             {
                 "fieldName": "price",
                 "trimmedChars": " ",
                 "type" : "Scalar"
             },
    "html body.toc p.row span.itempn" :
             {
                 "fieldName": "location",
                 "trimmedChars": " ()",
                 "type" : "Scalar"
             }
 }
 
 @return dictionary with map data
 */
- (NSDictionary*)parseDataMap:(NSString*)stringMapData encoding:(NSStringEncoding)encoding{
    
    NSError *error;
    //TODO: error processing; check that all needed keys are present
    NSDictionary* dMap = [NSJSONSerialization JSONObjectWithData:[stringMapData dataUsingEncoding:encoding] options:kNilOptions error:&error];
    return dMap;
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

/**
 Returns data map info for given path. If data is crossref to an another path, returns information for this original path 
 */
- (NSDictionary*)dataMapInfoForPath:(NSString *)path {
    NSDictionary* dataMapInfo = [_dataMap objectForKey:path];
    if ([[dataMapInfo allKeys] containsObject:kRefPath]) {
        NSString* origPath = [dataMapInfo objectForKey:kRefPath];
        dataMapInfo = [_dataMap objectForKey:origPath];
    }
    return dataMapInfo;
}

- (NSArray*) parse:(NSString*)htmlString {
    
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

    PathItemEx* pathItem = [[PathItemEx alloc] initItem:elementName withAttributes:attributeDict];
    [_pathStack push:pathItem];
    
    NSString* strPath = [_pathStack findMatchingPathInArray:_tokenizedPaths];
    if (nil != strPath)
    {
        [_pathStack setMatchedPath:strPath];
        NSDictionary *dataInfoDict = [self dataMapInfoForPath:strPath];
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
        }
    }];
}

- (void) parser:(DTHTMLParser *)parser foundCharacters:(NSString *)string {
    [_dataString appendString:string];
}

- (void) parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    
    NSString* strPath = [_pathStack currentMatchedPath];
    if (nil != strPath)
    {
        NSDictionary *dataInfoDict = [self dataMapInfoForPath:strPath];
        NSString *fieldName = [dataInfoDict objectForKey:kFieldName];
        NSString *objType = [dataInfoDict objectForKey:kObjectType];

        //may be we can extract some info from data by regexp
        [self parseUnparsed: _dataString withDataInfo:dataInfoDict];
        
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
    if (![fieldName isEqualToString:kUnusedFieldName]) {
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

- (NSString*) getDataFromString:(NSString*) stringData byRegexp:(NSString*)regexpString andTrimmedChars:(NSString*)trimmedChars {
    NSString* value = nil;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexpString
                                                                           options:0
                                                                             error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:stringData options:0 range:NSMakeRange(0, [stringData length])];
    if (match.numberOfRanges > 0)
    {
        NSRange range = match.numberOfRanges > 1 ? [match rangeAtIndex:1] : match.range;
        value = [[stringData substringWithRange:range] trimChars:trimmedChars];
    }
    return value;
}
@end


