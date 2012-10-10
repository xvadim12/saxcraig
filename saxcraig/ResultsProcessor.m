//
//  ResultsProcessor.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/9/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "ResultsProcessor.h"

@implementation ResultsProcessor

@synthesize URL;
@synthesize requestInfo;

- (void) dealloc {
    
    self.requestInfo = nil;
	self.URL = nil;
    [super dealloc];
}

- (NSObject*) parseResultArray:(NSArray*)resultArray {
	return [NSNull null];
}

@end
