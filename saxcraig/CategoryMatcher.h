//
//  CategoryMatcher.h
//  saxcraig
//
//  Created by Vadim Khohlov on 9/27/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryMatcher : NSObject

@property (nonatomic,retain) NSString* href;

//- (id) initWithCategoryData:(CategoryData*)catData;

- (id) initWithHref:(NSString*)href;

- (BOOL) isForSale;
- (BOOL) isHousing;
- (BOOL) isPersonals;
- (BOOL) isJobs;
- (BOOL) isGigs;
- (BOOL) isCommunity;
- (BOOL) isPartTimeJobs;

- (BOOL) isCommunityEvents;
- (BOOL) isCommunityClasses;
- (BOOL) isCarsAndTrucks;
- (BOOL) isFurniture;
- (BOOL) isApartmentsCGI;
- (BOOL) isLostAndFound;
- (BOOL) isRoomsShared;
- (BOOL) isWanted;
- (BOOL) isServices;

+ (BOOL) abreviationIsTopCategory:(NSString*) abr;

@end
