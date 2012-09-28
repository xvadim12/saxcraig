//
//  ParsingHelper.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/27/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "Defs.h"
#import "CategoryMatcher.h"
#import "ParsingHelper.h"

@implementation ParsingHelper

- (NSString*) parseOutPriceForTitle:(NSString**)title withMatcher:(CategoryMatcher*)matcher {
	NSString* price = nil;
	if ([matcher isHousing]) {
		price = [self parseOutHousePrice:title];
	} else if ([matcher isForSale]) {
		price = [self parseOutPrice:title];
	} else if ([matcher isPersonals]) {
		price = [self parseOutAge:title];
	}
	return price;
}

- (NSString*) parseOutPlace:(NSString**)title {
	//parsing out specific place if it is present
	NSString* place = nil;
	NSRange rangeOfPlace = [*title rangeOfString:@"\\([^)]*\\)$" options:NSRegularExpressionSearch];
	if (NSNotFound!=rangeOfPlace.location) {
		place = [*title substringWithRange:rangeOfPlace];
		place = [place stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
		*title = [*title substringToIndex:rangeOfPlace.location];
		*title = [*title stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" -"]];
	}
	//end parsing out place
	return place;
}

- (NSString*) parseOutHousePrice:(NSString**)title {
	NSString* price = nil;
	NSRange rangeOfPrice = [*title rangeOfString:@"^\\$[0-9]* / [^ ]*" options:NSRegularExpressionSearch];
    
	//if not yet found let's try just 2br
	if (NSNotFound==rangeOfPrice.location) {
		rangeOfPrice = [*title rangeOfString:@"^[0-9]*br " options:NSRegularExpressionSearch];
	}
	
	//if not found let's try: just $1123
	if (NSNotFound==rangeOfPrice.location) {
		rangeOfPrice = [*title rangeOfString:@"^\\$[0-9]* " options:NSRegularExpressionSearch];
	}
    
	if (NSNotFound!=rangeOfPrice.location) {
		price = [*title substringWithRange:rangeOfPrice];
		//price = [price stringByConvertingHTMLToPlainText];
		*title = [*title substringFromIndex:(rangeOfPrice.location+rangeOfPrice.length)];
		*title = [*title stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" -"]];
	}
	return price;
}

- (NSString*) parseOutPrice:(NSString**)title {
    NSRange rangeOfPrice = [*title rangeOfString:@"\\$[0-9]+$" options:NSRegularExpressionSearch];
	NSString* price = nil;
    if (NSNotFound!=rangeOfPrice.location) {
		price = [*title substringWithRange:rangeOfPrice];
        *title = [*title substringToIndex:(rangeOfPrice.location)];
		*title = [*title stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" -"]];
   	}
	return price;
}

- (NSString*) parseOutAge:(NSString**)title  {
	NSString* price = nil;
	NSRange rangeOfPrice = [*title rangeOfString:@"[0-9]+yr$" options:NSRegularExpressionSearch];
	//check age
	if (NSNotFound==rangeOfPrice.location) {
		rangeOfPrice = [*title rangeOfString:@"[0-9]+$" options:NSRegularExpressionSearch];
	}
	
	if (NSNotFound!=rangeOfPrice.location) {
		price = [*title substringWithRange:rangeOfPrice];
		*title = [*title substringToIndex:(rangeOfPrice.location)];
		*title = [*title stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" -"]];
	}
	return price;
}

@end
