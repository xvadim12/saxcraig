//
//  UnitTestHelper.m
//  saxcraig
//
//  Created by Vadim A. Khohlov on 9/12/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "UnitTestHelper.h"

@implementation UnitTestHelper


- (NSString*)contentsOfFile:(NSString*)fileName {
    return [self contentsOfFile:fileName withType:@"html"];
}

- (NSString*)contentsOfFile:(NSString*)fileName withType:(NSString*)fileType {
	NSError* err = nil;
	NSBundle* bundle = [NSBundle bundleForClass:[self class]];
	NSString* path = [bundle pathForResource:fileName ofType:fileType];
	NSString* testString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    if (err) {
        NSLog(@"Error in %@: %@", NSStringFromSelector(_cmd), err);
    }
	return testString;
}
@end
