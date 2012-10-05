//
//  ParametrizedSAXParser.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/19/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "ParametrizedSAXParser.h"

NSString* const ATTR_ID = @"id";
NSString* const ATTR_CLASS = @"class";
NSString* const ATTR_NAME = @"name";

//Keys for data map
NSString* const kFieldName = @"fieldName";
NSString* const kTrimmedChars = @"trimmedChars";
NSString* const kObjectType = @"type";
NSString* const kAttributesKey = @"attributes";

NSString* const kScalarObject = @"Scalar";
NSString* const kDictObject   = @"Dict";

//Keys in result subdictionaries
NSString* const kDataKey = @"data";
NSString* const kFieldNameKey = @"fieldName";
NSString* const kRegexpKey = @"regexp";

@interface Stack: NSObject {
    NSMutableArray* _data;
}

- (void) push: (id)item;
- (id) pop;
- (void) clear;
@end


@implementation Stack

- (id)init; {
    if (self = [super init])
        _data = [NSMutableArray array];
    return self;
}

- (void) dealloc {
	_data = nil;
    
	[super dealloc];
}

- (void) push: (id)item {
    [_data addObject:item];
}

- (id) pop {
    id obj = nil;
    if ([_data count] != 0)
    {
        obj = [[[_data lastObject] retain] autorelease];
        [_data removeLastObject];
    }
    return obj;
}

- (void) clear {
    [_data removeAllObjects];
}
@end

/**
 Simple stack for saving current path in the file
 */
@interface PathStack: Stack

- (NSString*) stringPath;
- (NSString*) findMatchingPathInArray:(NSArray*)allPaths;
@end


@implementation PathStack

- (id) pop {
    //in the path stack we don't need poped value. So, use more simple implementation without plaing with retain & autorelease
    [_data removeLastObject];
    return nil;
}

/**
 Builds string representation of current path from current state of path stack
 */
- (NSString*) stringPath {
    
    NSMutableString *strPath = [NSMutableString stringWithString:@""];
    for(NSString *subPath in _data)
        [strPath appendFormat:@" %@", subPath];
    return [strPath substringFromIndex:1];
}

- (NSString*) findMatchingPathInArray:(NSArray*)allPaths {
    NSString *strPath = [self stringPath];
    if (NSNotFound == [allPaths indexOfObject:strPath])
        return nil;
    else
        return strPath;
}

@end


@interface NSString (StringWithTrim)
- (NSString*)trimChars:(NSString*)trimmedChars;
@end

@implementation NSString (StringWithTrim)
- (NSString*)trimChars:(NSString*)trimmedChars {
    
    NSMutableCharacterSet* trimmCharset = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    if (nil != trimmedChars)
        [trimmCharset addCharactersInString:trimmedChars];
    
    return  [self stringByTrimmingCharactersInSet:trimmCharset];
}
@end


@implementation ParametrizedSAXParser {
    
    DTHTMLParser* _htmlParser;
    
    NSDictionary* _dataMap;
    
    //Regexps for extaricring data from unparsed block
    NSMutableDictionary* _fieldRegexps;
    
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

@synthesize URL;
@synthesize requestInfo;

- (id) initWithDataMap:(NSString*)stringDataMap {
    
    if (self = [super init]) {
        
        _dataStack = [[Stack alloc] init];
        _pathStack = [[PathStack alloc] init];
        
        _dataString = [[NSMutableString alloc] init];
        _parsedObject = nil;
        
        _resultObject = [NSMutableArray array];
        _fieldRegexps = [[NSMutableDictionary alloc] init];
        
        _dataMap = [self parseDataMap:stringDataMap encoding:NSUTF8StringEncoding];
    }
    
    return self;
}

- (void) dealloc {
    
    self.requestInfo = nil;
	self.URL = nil;
    
    [_pathStack release];
    _pathStack = nil;
    
    [_dataStack release];
    _dataStack = nil;
    
    _dataString = nil;
    [_parsedObject release];
    _parsedObject = nil;

    _dataMap = nil;
    
    [_fieldRegexps release];
    _fieldRegexps = nil;
    
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
 
 @return dictionary with mat data
 */
- (NSDictionary*)parseDataMap:(NSString*)stringMapData encoding:(NSStringEncoding)encoding{
    
    NSError *error;
    //TODO: error processing; check that all needed keys are present
    NSDictionary* dMap = [NSJSONSerialization JSONObjectWithData:[stringMapData dataUsingEncoding:encoding] options:kNilOptions error:&error];
    
    //build dict with field's regexps
    for (NSString* key in [dMap allKeys]){
        NSDictionary* item = [dMap objectForKey:key];
        NSString* regexp = [item objectForKey:kRegexpKey];
        if (nil != regexp) {
            [_fieldRegexps setObject:[NSDictionary dictionaryWithObjectsAndKeys:regexp, kRegexpKey,
                                          [item objectForKey:kTrimmedChars], kTrimmedChars,
                                          nil] forKey:[item objectForKey:kFieldName]];
        }
    }
    
    return dMap;
}

- (NSObject*) parseHTML:(NSString*)htmlString {
    return [self parseResultArray:[self parse:htmlString]];
}

- (NSObject*) parseResultArray:(NSArray*)resultArray {
	return [NSNull null];
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

- (void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
    NSString* elementId = [attributeDict objectForKey:ATTR_ID];   //get id of tag if present
    NSString* elementClass = [attributeDict objectForKey:ATTR_CLASS]; //try to get class of tag
    NSString* elName = [attributeDict objectForKey:ATTR_NAME];
    
    NSString* subPath;
    if (nil != elName)
        subPath = [NSString stringWithFormat:@"%@[name=%@]", elementName, elName];
    else if (nil != elementClass)
        subPath = [NSString stringWithFormat:@"%@.%@", elementName, elementClass];
    else if (nil != elementId)
        subPath = [NSString stringWithFormat:@"%@#%@", elementName, elementId];
    else
        subPath = [NSString stringWithString:elementName];
    
    [_pathStack push:subPath];
    NSString* strPath = [_pathStack findMatchingPathInArray:[_dataMap allKeys]];
    if (nil != strPath)
    {
        NSDictionary *dataInfoDict = [_dataMap objectForKey:strPath];
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

- (void)parseAttributes:(NSDictionary *)attributeDict withDataMap:(NSDictionary*)subDataMap {
    [subDataMap enumerateKeysAndObjectsUsingBlock:^(id key, id dataInfoDict, BOOL *stop) {
        NSString *attrValue = [attributeDict objectForKey:key];
        if (nil != attrValue)
        {
            //assume that tag's attributes contain only scalar objects
            [self saveScalarObject:attrValue withFieldName:[dataInfoDict objectForKey:kFieldName] andDataInfo:dataInfoDict];
        }
    }];
}

- (void)parser:(DTHTMLParser *)parser foundCharacters:(NSString *)string {
    [_dataString appendString:string];
}

- (void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    
    NSString* strPath = [_pathStack findMatchingPathInArray:[_dataMap allKeys]];
    
    if (nil != strPath)
    {
        NSDictionary *dataInfoDict = [_dataMap objectForKey:strPath];
        NSString *fieldName = [dataInfoDict objectForKey:kFieldName];
        NSString *objType = [dataInfoDict objectForKey:kObjectType];

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
            if (![_dataString isEqualToString:@""])
                [self saveScalarObject:_dataString withFieldName:@"unparsed" andDataInfo:dataInfoDict];
            
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
    if (nil == _parsedObject)
    {
        [_resultObject addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                fieldName, kFieldNameKey,
                                [value trimChars:[dataInfoDict objectForKey:kTrimmedChars]], kDataKey, nil]];
    }
    else
        [_parsedObject setValue:[value trimChars:[dataInfoDict objectForKey:kTrimmedChars]] forKey:fieldName];
}

- (NSString*) getDataFromDict:(NSDictionary*)dict withKey:(NSString*) key withUnparsedData:(NSString*)unparsed andRegexpKey:(NSString*)regexpKey {

    NSString* value = nil!= dict ? [dict objectForKey:key] : nil;
    if (nil == value && nil != unparsed && nil != regexpKey) {
        NSDictionary* rexp = [_fieldRegexps objectForKey:regexpKey];
        if (nil != rexp) {
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[rexp objectForKey:kRegexpKey]
                                                                                   options:0         
                                                                                     error:&error];
            NSRange range = [regex rangeOfFirstMatchInString:unparsed options:0 range:NSMakeRange(0, [unparsed length])];
            if (NSNotFound != range.location)
                value = [[unparsed substringWithRange:range] trimChars:[rexp objectForKey:kTrimmedChars]];
        }
    }
    return value;
}

@end


