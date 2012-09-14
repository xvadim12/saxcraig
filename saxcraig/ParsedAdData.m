//
//  ParsedAdData.m
//  saxcraig
//
//  Created by Vadim A. Khohlov on 9/13/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "ParsedAdData.h"

@implementation ParsedAdData

@synthesize title;
@synthesize link;
@synthesize price;
@synthesize location;

- (void) dealloc {
	self.title = nil;
	self.link = nil;
	self.price = nil;
	self.location = nil;

	[super dealloc];
}

@end
