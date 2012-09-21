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
#define kAttributesKey @"attributes"

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
        
        _dataMap = [self parseDataMap:stringDataMap encoding:encoding];
        
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
 
 Next structure is expected:
 
 {
    path_to_object1 : { - dict with information about object
                        'fieldName': name of field in result dict,
                        'trimmedChars': string with chars which will be trimmed from start and end of value
                        'type': type of object - 0 for scalar, 1 for dict, i.e. nested object
 
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
                 "type" : 0
             },
    "html body.toc p.row" :
             {
                "fieldName": "ads",
                "type" : 1
             },
    "html body.toc p.row a" :
             {
                 "fieldName": "title",
                 "trimmedChars": " ",
                 "type" : 0,
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
                 "type" : 0
             },
    "html body.toc p.row span.itempn" :
             {
                 "fieldName": "location",
                 "trimmedChars": " ()",
                 "type" : 0
             }
 }
 
 @return dictionary with mat data
 */
- (NSDictionary*)parseDataMap:(NSString*)stringMapData encoding:(NSStringEncoding)encoding{
    
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
        if ([[dataInfoDict valueForKey:kObjectType] intValue] == kScalarObject)
            [_dataString setString:@""];
        else
            _parsedObject = [[NSMutableDictionary alloc] init];
        
        NSDictionary *subDataMap = [dataInfoDict objectForKey:kAttributesKey];
        if (nil != subDataMap)
            [self parseAttributes:attributeDict withDataMap:subDataMap];
    }
}

- (void)parseAttributes:(NSDictionary *)attributeDict withDataMap:(NSDictionary*)subDataMap {
    [subDataMap enumerateKeysAndObjectsUsingBlock:^(id key, id dataInfoDict, BOOL *stop) {
        NSString *attrValue = [attributeDict valueForKey:key];
        if (nil != attrValue)
        {
            //assume that tag's attributes contain only scalar objects
            NSString *fieldName = [dataInfoDict valueForKey:kFieldName];
            NSMutableArray *dataArray = [self getDataArrayForObjectWithType:kScalarObject forField:fieldName];
            [self saveScalarObject:attrValue to:dataArray withFieldName:fieldName andDataInfo:dataInfoDict];
        }
    }];
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
        
        //get object for saving
        NSMutableArray *dataArray = [self getDataArrayForObjectWithType:objType forField:fieldName];

        //... and add a new value
        if (objType == kScalarObject)
            [self saveScalarObject:_dataString to:dataArray withFieldName:fieldName andDataInfo:dataInfoDict];
        else
        {
            [dataArray addObject: _parsedObject];
            [_parsedObject release];
            _parsedObject = nil;
        }
    }
    
    [_pathStack pop];
}

/**
 Returns object for saving data. Creates a new one if key doesn't exists
 @return NSMutableArray array
 */
-(NSMutableArray*)getDataArrayForObjectWithType:(int)objectType forField:(NSString*)fieldName {
    NSMutableArray *dataArray = nil;
    
    //create a new key in results only for objects or scalars of first level
    if ((nil == _parsedObject && objectType == kScalarObject) || objectType == kDictObject)
    {
        //assume that all objects are arrays (for more simple parser)
        //some objects like ad list title will be presented by array with one item
        dataArray = (NSMutableArray*)[_resultDictionary valueForKey:fieldName];
        if (nil == dataArray) {
            dataArray = [NSMutableArray array];
            [_resultDictionary setValue:dataArray forKey:fieldName];
        }
    }
    return dataArray;
}

/**
 Saves scalar object to dataArray or to _parsedObject dictionary
 */
-(void)saveScalarObject:(NSString*)value to:(NSMutableArray*)dataArray withFieldName:(NSString*)fieldName andDataInfo:(NSDictionary*)dataInfoDict {
    if (nil == _parsedObject)
        [dataArray addObject:[value trimChars:[dataInfoDict valueForKey:kTrimmedChars]]];
    else
        [_parsedObject setValue:[value trimChars:[dataInfoDict valueForKey:kTrimmedChars]] forKey:fieldName];
}

@end


