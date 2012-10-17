//
//  DataMap.h
//  saxcraig
//
//  Created by Vadim Khohlov on 10/15/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <Foundation/Foundation.h>

//Keys for data map
extern NSString* const kFieldName;
extern NSString* const kTrimmedChars;
extern NSString* const kObjectType;
extern NSString* const kAttributesKey;
extern NSString* const kUnparsedRegExpsKey;
extern NSString* const kRefPath;
extern NSString* const kUnusedFieldName;

extern NSString* const kScalarObject;
extern NSString* const kDictObject;

//Keys in result subdictionaries
extern NSString* const kDataKey;
extern NSString* const kFieldNameKey;

@class ResultsProcessor;

@interface DataMap : NSObject

@property (nonatomic, retain) NSDictionary* tokenizedPaths;
@property (nonatomic, retain) NSString* version;
@property (nonatomic, retain) ResultsProcessor* resultsProcessor;

/**
 Creates a new DataMap object from astring representation of map data.
 
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
*/

- (id)initWithString:(NSString*)stringMapData encoding:(NSStringEncoding)encoding;

/**
 Returns data map info for given path. If data is crossref to an another path, returns information for this original path
 */
- (NSDictionary*)dataMapInfoForPath:(NSString *)path;

@end
