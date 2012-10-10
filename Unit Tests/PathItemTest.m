//
//  PathItemTest.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/10/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "PathItemTest.h"

#import "PathItem.h"

@implementation PathItemTest

- (void) testEqualItems {
    PathItem* dataMapItemP = [[[PathItem alloc] initItem:@"p" withName:nil andID:nil andClass:nil] autorelease];
    PathItem* itemP = [[[PathItem alloc] initItem:@"p" withName:nil andID:nil andClass:nil] autorelease];
    PathItem* itemPName = [[[PathItem alloc] initItem:@"p" withName:@"123" andID:nil andClass:nil] autorelease];
    PathItem* itemPID = [[[PathItem alloc] initItem:@"p" withName:nil andID:@"123" andClass:nil] autorelease];
    PathItem* itemPClass = [[[PathItem alloc] initItem:@"p" withName:nil andID:nil andClass:@"row"] autorelease];
    
    STAssertTrue([dataMapItemP isEqualToItem:dataMapItemP], @"Items should be equal");
    STAssertTrue([dataMapItemP isEqualToItem:itemP], @"Items should be equal");
    STAssertTrue([dataMapItemP isEqualToItem:itemPName], @"Items should be equal");
    STAssertTrue([dataMapItemP isEqualToItem:itemPID], @"Items should be equal");
    STAssertTrue([dataMapItemP isEqualToItem:itemPClass], @"Items should be equal");
}

- (void) testEqualItemsName {
    PathItem* dataMapItemP = [[[PathItem alloc] initItem:@"p" withName:@"name" andID:nil andClass:nil] autorelease];
    PathItem* itemPName = [[[PathItem alloc] initItem:@"p" withName:@"name" andID:nil andClass:nil] autorelease];
    PathItem* itemPID = [[[PathItem alloc] initItem:@"p" withName:@"name" andID:@"123" andClass:nil] autorelease];
    PathItem* itemPClass = [[[PathItem alloc] initItem:@"p" withName:@"name" andID:nil andClass:@"row"] autorelease];
    
    STAssertTrue([dataMapItemP isEqualToItem:itemPName], @"Items should be equal");
    STAssertTrue([dataMapItemP isEqualToItem:itemPID], @"Items should be equal");
    STAssertTrue([dataMapItemP isEqualToItem:itemPClass], @"Items should be equal");
}

- (void) testEqualItemsID {
    PathItem* dataMapItemP = [[[PathItem alloc] initItem:@"p" withName:nil andID:@"id" andClass:nil] autorelease];
    PathItem* itemPName = [[[PathItem alloc] initItem:@"p" withName:@"123" andID:@"id" andClass:nil] autorelease];
    PathItem* itemPID = [[[PathItem alloc] initItem:@"p" withName:nil andID:@"id" andClass:nil] autorelease];
    PathItem* itemPClass = [[[PathItem alloc] initItem:@"p" withName:nil andID:@"id" andClass:@"row"] autorelease];
    
    STAssertTrue([dataMapItemP isEqualToItem:itemPName], @"Items should be equal");
    STAssertTrue([dataMapItemP isEqualToItem:itemPID], @"Items should be equal");
    STAssertTrue([dataMapItemP isEqualToItem:itemPClass], @"Items should be equal");
}

- (void) testEqualItemsClass {
    PathItem* dataMapItemP = [[[PathItem alloc] initItem:@"p" withName:nil andID:nil andClass:@"row"] autorelease];
    PathItem* itemPName = [[[PathItem alloc] initItem:@"p" withName:@"123" andID:nil andClass:@"row"] autorelease];
    PathItem* itemPID = [[[PathItem alloc] initItem:@"p" withName:nil andID:@"123" andClass:@"row"] autorelease];
    PathItem* itemPClass = [[[PathItem alloc] initItem:@"p" withName:nil andID:nil andClass:@"row"] autorelease];
    
    STAssertTrue([dataMapItemP isEqualToItem:itemPName], @"Items should be equal");
    STAssertTrue([dataMapItemP isEqualToItem:itemPID], @"Items should be equal");
    STAssertTrue([dataMapItemP isEqualToItem:itemPClass], @"Items should be equal");
}

- (void) testEqualItemsFull {
    PathItem* dataMapItemP = [[[PathItem alloc] initItem:@"p" withName:@"name" andID:@"id" andClass:@"row"] autorelease];
    PathItem* itemPName = [[[PathItem alloc] initItem:@"p" withName:@"name" andID:@"id" andClass:@"row"] autorelease];
    
    STAssertTrue([dataMapItemP isEqualToItem:itemPName], @"Items should be equal");
}

- (void) testNonEqualItems {
    PathItem* dataMapItemP = [[[PathItem alloc] initItem:@"p" withName:nil andID:nil andClass:nil] autorelease];
    PathItem* itemPName = [[[PathItem alloc] initItem:@"p" withName:@"123" andID:nil andClass:nil] autorelease];
    PathItem* itemPID = [[[PathItem alloc] initItem:@"p" withName:nil andID:@"123" andClass:nil] autorelease];
    PathItem* itemPClass = [[[PathItem alloc] initItem:@"p" withName:nil andID:nil andClass:@"row"] autorelease];
    
    PathItem* itemH = [[[PathItem alloc] initItem:@"h" withName:nil andID:nil andClass:nil] autorelease];
    
    STAssertFalse([itemPName isEqualToItem:dataMapItemP], @"Items shouldn't be equal");
    STAssertFalse([itemPID isEqualToItem:dataMapItemP], @"Items shouldn't be equal");
    STAssertFalse([itemPClass isEqualToItem:dataMapItemP], @"Items shouldn't be equal");
    
    STAssertFalse([dataMapItemP isEqualToItem:itemH], @"Items shouldn't be equal");
}

- (void) testNonEqualItemsFull {
    PathItem* dataMapItemP = [[[PathItem alloc] initItem:@"p" withName:@"name" andID:@"id" andClass:@"class"] autorelease];
    PathItem* itemPName = [[[PathItem alloc] initItem:@"p" withName:@"nameWrong" andID:@"id" andClass:@"class"] autorelease];
    PathItem* itemPID = [[[PathItem alloc] initItem:@"p" withName:@"name" andID:@"idWrong" andClass:@"class"] autorelease];
    PathItem* itemPClass = [[[PathItem alloc] initItem:@"p" withName:@"name" andID:@"id" andClass:@"classWrong"] autorelease];
    
    STAssertFalse([dataMapItemP isEqualToItem: itemPName], @"Items shouldn't be equal");
    STAssertFalse([dataMapItemP isEqualToItem: itemPID], @"Items shouldn't be equal");
    STAssertFalse([dataMapItemP isEqualToItem: itemPClass], @"Items shouldn't be equal");
}

- (void) pathItemTesting:(PathItem*)item tagName:(NSString*)tagName elName:(NSString*)elName elID:(NSString*)elID elClass:(NSString*)elClass {
    STAssertEqualObjects(tagName, item.elementTagName, @"Wrong tag name %@", item.elementTagName);
    STAssertEqualObjects(elName, item.elementName, @"Wrong tag element name %@", item.elementName);
    STAssertEqualObjects(elID, item.elementID, @"Wrong tag id %@", item.elementID);
    STAssertEqualObjects(elClass, item.elementClass, @"Wrong tag class %@", item.elementClass);
}

- (void) testInit {
    NSString* tagName = @"p";
    NSString* elName = @"name";
    NSString* elID = @"id";
    NSString* elClass = @"class";
    
    PathItem* item = [[[PathItem alloc] initItem:tagName
                                  withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:elName, ATTR_NAME,
                                                        elID, ATTR_ID, elClass, ATTR_CLASS, nil]] autorelease];
    [self pathItemTesting:item tagName:tagName elName:elName elID:elID elClass:elClass];
    
    NSString* itemString = [NSString stringWithFormat:@"%@[%@]", tagName, elName];
    item = [[[PathItem alloc] initItemFromString:itemString] autorelease];
    [self pathItemTesting:item tagName:tagName elName:elName elID:nil elClass:nil];
    
    itemString = [NSString stringWithFormat:@"%@#%@", tagName, elID];
    item = [[[PathItem alloc] initItemFromString:itemString] autorelease];
    [self pathItemTesting:item tagName:tagName elName:nil elID:elID elClass:nil];
    
    itemString = [NSString stringWithFormat:@"%@.%@", tagName, elClass];
    item = [[[PathItem alloc] initItemFromString:itemString] autorelease];
    [self pathItemTesting:item tagName:tagName elName:nil elID:nil elClass:elClass];
}

@end
