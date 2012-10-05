//
//  AdData.m
//  saxcraig
//
//  Created by Vadim Khohlov on 9/27/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "AdData.h"

@implementation AdData

@synthesize title;
@synthesize descr;
@synthesize link;
@synthesize date;
@synthesize created;
@synthesize price;
@synthesize place;
@synthesize relativeTime;
@synthesize body;
@synthesize thumbnailLink;

@synthesize imageURLs;
@synthesize postingID;
@synthesize phone;
@synthesize isFavorite;
@synthesize isMarkedOff;
@synthesize mailto;
@synthesize replyURL;
@synthesize isViewed;
//@synthesize categoryData;
//@synthesize locationData;
@synthesize hideLocation;

- (void) dealloc {
	self.title = nil;
	self.descr = nil;
	self.link = nil;
	self.date = nil;
    self.created = nil;
	self.price = nil;
	self.place = nil;
	self.body = nil;
    self.thumbnailLink = nil;
    
	self.relativeTime = nil;
	self.imageURLs = nil;
	self.postingID = nil;
	self.phone = nil;
	self.mailto = nil;
	self.replyURL = nil;
//	self.categoryData = nil;
//    self.locationData = nil;
	[super dealloc];
}

- (NSString*) descr {
	if (nil==descr && [body length]>0) {
		self.descr = [body stringByReplacingOccurrencesOfString:@"\\s+" withString:@" "
                                                        options:NSRegularExpressionSearch
                                                          range:NSMakeRange(0, body.length)];
	}
	return descr;
}

- (NSString*) phone {
	if (nil==phone && [body length]>0) {
		NSArray* regexpPhone = [NSArray arrayWithObjects:
								@"[0-9]{3}\\.[0-9]{3}\\.[0-9]{4}",
								@"\\([0-9]{3}\\) ?[0-9]{3}-[0-9]{4}",
								@"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}",nil];
		for (NSString* regexp in regexpPhone) {
			NSRange range = [body rangeOfString:regexp options:NSRegularExpressionSearch];
			if (NSNotFound!=range.location && 0!=range.length) {
				self.phone = [body substringWithRange:range];
				break;
			}
		}
	}
	return phone;
}

@end
