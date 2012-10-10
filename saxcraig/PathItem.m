//
//  PathItem.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/10/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "PathItem.h"

NSString* const ATTR_ID = @"id";
NSString* const ATTR_CLASS = @"class";
NSString* const ATTR_NAME = @"name";

NSString* const SEPARATOR_NAME = @"[";
NSString* const SEPARATOR_ID = @"#";
NSString* const SEPARATOR_CLASS = @".";

@implementation PathItem

@synthesize elementTagName;
@synthesize elementName;
@synthesize elementID;
@synthesize elementClass;

- (void) dealloc {
    
    elementTagName = nil;
    elementName = nil;
    elementID = nil;
    elementClass = nil;
    
	[super dealloc];
}

- (id) initItem:(NSString*)tagName withName:(NSString*)elemName andID:(NSString*)elemID andClass:(NSString*)elemClass {
    if (self = [super init])
    {
        self.elementTagName = tagName;
        self.elementName = elemName;
        self.elementID = elemID;
        self.elementClass = elemClass;
    }
    return self;
}

- (id) initItem:(NSString*)tagName withAttributes:(NSDictionary*)attributes {
    return [self initItem:tagName withName:[attributes objectForKey:ATTR_NAME] andID:[attributes objectForKey:ATTR_ID] andClass:[attributes objectForKey:ATTR_CLASS]];
}

- (id) initItemFromString:(NSString*)string {
    NSString* tagName = nil;
    NSString* elName = nil;
    NSString* elID = nil;
    NSString* elClass = nil;
    
    NSArray* components = [string componentsSeparatedByString:SEPARATOR_NAME];
    if ([components count] > 1) {
        tagName = [components objectAtIndex:0];
        elName = [[components objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"]"]];
    } else {
        components = [string componentsSeparatedByString:SEPARATOR_ID];
        if ([components count] > 1) {
            tagName = [components objectAtIndex:0];
            elID = [components objectAtIndex:1];
        } else {
            components = [string componentsSeparatedByString:SEPARATOR_CLASS];
            if ([components count] > 1) {
                tagName = [components objectAtIndex:0];
                elClass = [components objectAtIndex:1];
            } else {
                tagName = [NSString stringWithString:string];
            }
        }
    }
    return [self initItem:tagName withName:elName andID:elID andClass:elClass];
}

- (BOOL) isEqualToItem:(PathItem*)item {
    BOOL isEqual = NO;
    if([self.elementTagName isEqualToString:item.elementTagName]) {
        if ((nil == self.elementName || [self.elementName isEqualToString:item.elementName]) &&
            (nil == self.elementID || [self.elementID isEqualToString:item.elementID]) &&
            (nil == self.elementClass || [self.elementClass isEqualToString:item.elementClass]))
                isEqual = YES;
    }
    return isEqual;
}

@end
