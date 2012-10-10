//
//  PathItem.h
//  saxcraig
//
//  Created by Vadim Khohlov on 10/10/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const ATTR_ID;;
extern NSString* const ATTR_CLASS;
extern NSString* const ATTR_NAME;

@interface PathItem : NSObject

@property (nonatomic,retain) NSString* elementTagName;
@property (nonatomic,retain) NSString* elementName;
@property (nonatomic,retain) NSString* elementID;
@property (nonatomic,retain) NSString* elementClass;

- (id) initItem:(NSString*)tagName withName:(NSString*)elementName andID:(NSString*)elementID andClass:(NSString*)elementClass;

- (id) initItem:(NSString*)tagName withAttributes:(NSDictionary*)attributes;

/**
 Only one of the attributes are suported at this moment, i.e. supported strings:
 - tagName[name]
 - tagName#id
 - tagName.class
 */
- (id) initItemFromString:(NSString*)string;

- (BOOL) isEqualToItem:(PathItem*)item;

@end
