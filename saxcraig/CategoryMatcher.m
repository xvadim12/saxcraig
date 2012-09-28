//
//  CategoryMatcher.m
//  LifelikeClassifieds
//
//  Created by Eugene Dorfman on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Defs.h"
#import "CategoryMatcher.h"


@implementation CategoryMatcher
@synthesize href;

- (void) dealloc {
	self.href = nil;
	[super dealloc];
}

- (id) initWithHref:(NSString*)_href {
	if ((self = [super init])) {
		self.href = _href;
	}
	return self;
}

/*
- (id) initWithCategoryData:(CategoryData*)catData {
    if ((self = [super init])) {
        CategoryData* categoryData = catData.parent ? catData.parent : catData;
        self.href = categoryData.href;
    }
    return self;
}
*/
- (BOOL) isForSale {
	NSRange range = [self.href rangeOfString:HREF_FORSALE options:NSCaseInsensitiveSearch];
	return NSNotFound!=range.location;
}

- (BOOL) isHousing {
	NSRange range = [self.href rangeOfString:HREF_HOUSING options:NSCaseInsensitiveSearch];
	return NSNotFound != range.location;
}

- (BOOL) isServices {
    NSRange range = [self.href rangeOfString:HREF_SERVICES options:NSCaseInsensitiveSearch];
	return NSNotFound != range.location;
}

- (BOOL) isPersonals {
 	NSRange range = [self.href rangeOfString:HREF_PERSONALS options:NSCaseInsensitiveSearch];
 	return NSNotFound!=range.location && self.href;
}

- (BOOL) isJobs {
	NSRange range = [self.href rangeOfString:HREF_JOBS options:NSCaseInsensitiveSearch];
	return NSNotFound!=range.location;
}

- (BOOL) isGigs {
	NSRange range = [self.href rangeOfString:HREF_GIGS options:NSCaseInsensitiveSearch];
	return NSNotFound!=range.location;
}

- (BOOL) isPartTimeJobs {
	NSRange range = [self.href rangeOfString:HREF_PARTTIME options:NSCaseInsensitiveSearch];
	return NSNotFound!=range.location;
}

- (BOOL) isCommunity {
	NSRange range = [self.href rangeOfString:HREF_COMMUNITY options:NSCaseInsensitiveSearch];
	return NSNotFound!=range.location;
}

- (BOOL) isCommunityEvents {
	if ([self isCommunityClasses])
		return NO;
	NSRange range = [self.href rangeOfString:HREF_CAL options:NSCaseInsensitiveSearch];
	return NSNotFound!=range.location;
}

- (BOOL) isCommunityClasses {
	NSRange range = [self.href rangeOfString:HREF_CLASSES options:NSCaseInsensitiveSearch];
	return NSNotFound!=range.location;
}

- (BOOL) isCarsAndTrucks {
	NSRange range = [self.href rangeOfString:HREF_CARSANDTRUCKS options:NSCaseInsensitiveSearch];
	return NSNotFound!=range.location;
}

- (BOOL) isFurniture {
	NSRange range = [self.href rangeOfString:HREF_FURNITURE options:NSCaseInsensitiveSearch];
	return NSNotFound!=range.location;
}

- (BOOL) isApartmentsCGI {
	NSRange range = [self.href rangeOfString:HREF_APARTMENTSCGI options:NSCaseInsensitiveSearch];
	return NSNotFound!=range.location;
}

- (BOOL) isLostAndFound {
	NSRange range = [self.href rangeOfString:HREF_LOSTANDFOUND options:NSCaseInsensitiveSearch];
	return NSNotFound!=range.location;
}

- (BOOL) isRoomsShared {
	NSRange range = [self.href rangeOfString:HREF_ROOMSSHARED options:NSCaseInsensitiveSearch];
	return NSNotFound!=range.location;
}

- (BOOL) isWanted {
	NSRange range = [self.href rangeOfString:HREF_WANTED options:NSCaseInsensitiveSearch];
	return NSNotFound!=range.location;
}

+ (BOOL) abreviationIsTopCategory:(NSString*) abr{
    NSArray* topCategoriesHrefs = [NSArray arrayWithObjects:HREF_JOBS,HREF_FORSALE,HREF_HOUSING,HREF_GIGS,HREF_COMMUNITY,
                                   HREF_SERVICES,HREF_RESUMES,HREF_PERSONALS,nil];
    return [topCategoriesHrefs containsObject:abr];
}

@end
