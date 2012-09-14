//
//  SAXParserTest.m
//  saxcraig
//
//  Created by Vadim A. Khohlov on 9/12/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "SAXParserTest.h"
#import "UnitTestHelper.h"

@implementation SAXParserTest

@synthesize unitTestHelper;

- (void) dealloc {
	self.unitTestHelper = nil;
	[super dealloc];
}

- (void) setUp {
	if (nil==self.unitTestHelper) {
		self.unitTestHelper = [[[UnitTestHelper alloc] init] autorelease];
	}
}

@end
