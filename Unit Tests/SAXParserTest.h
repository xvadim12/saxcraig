//
//  SAXParserTest.h
//  saxcraig
//
//  Created by Vadim A. Khohlov on 9/12/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class UnitTestHelper;

@interface SAXParserTest : SenTestCase

@property (nonatomic, retain) UnitTestHelper* unitTestHelper;
@property (nonatomic, retain) NSArray* dataMapFiles;
@property (nonatomic, retain) NSString* dataMapDir;

- (void)removeDataMaps;

@end
