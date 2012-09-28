//
//  NSStringAdditions.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/27/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "NSStringAdditions.h"

@implementation NSString (Additions)

- (NSString*) stringByAppendingURLComponent:(NSString*)url {
	if (0==[url length])
		return self;
    
	const unichar SLASH = '/';
	NSRange range = NSMakeRange(1, [url length]-1);
	NSString* urlToAppend = SLASH == [url characterAtIndex:0] ? [url substringWithRange:range] : url;
    
	NSString* result = nil;
	if (0==[self length]) {
		result = urlToAppend;
        //DLog(@"%@",result); // just to prevent annoying warning
    }
    
	if ('/'==[self characterAtIndex:([self length]-1)]) {
		result = [self stringByAppendingString:urlToAppend];
	} else {
		result = [self stringByAppendingFormat:@"/%@",urlToAppend];
	}
    
	return result;
}

- (NSRange) rangeBetweenFirst:(NSString*)first andSecond:(NSString*)second withinRange:(NSRange)range {
	NSRange rangeBetween = NSMakeRange(NSNotFound, 0);
	if (NSNotFound == range.location || 0 == range.length)
		return rangeBetween;
    
	NSRange rangeOfFirst = [self rangeOfString:first options:0 range:range];
    
	if (NSNotFound == rangeOfFirst.location)
		return rangeBetween;
    
	NSUInteger firstLocation = rangeOfFirst.location+[first length];
    
	NSRange rangeOfSecond = NSMakeRange(firstLocation, range.length - (firstLocation-range.location));
	if (NSNotFound == rangeOfSecond.location || rangeOfSecond.length<=0)
		return rangeBetween;
    
	rangeOfSecond = [self rangeOfString:second options:0 range:rangeOfSecond];
    
	if (NSNotFound == rangeOfSecond.location)
		return rangeBetween;
	rangeBetween = NSMakeRange(firstLocation,rangeOfSecond.location-firstLocation);
	return rangeBetween;
}

- (NSRange) rangeBetweenFirst:(NSString*)first andSecond:(NSString*)second {
	NSRange allRange = NSMakeRange(0, [self length]);
	return [self rangeBetweenFirst:first andSecond:second withinRange:allRange];
}

- (NSString*) substringBetweenFirst:(NSString*)first andSecond:(NSString*)second withinRange:(NSRange)range {
	NSRange rangeBetween = [self rangeBetweenFirst:first andSecond:second withinRange:range];
	if (NSNotFound==rangeBetween.location || 0==rangeBetween.length)
		return nil;
	NSString* between = [self substringWithRange:rangeBetween];
	return between;
}

- (NSString*) substringBetweenFirst:(NSString*)first andSecond:(NSString*)second {
	NSRange allRange = NSMakeRange(0, [self length]);
	return [self substringBetweenFirst:first andSecond:second withinRange:allRange];
}

@end
