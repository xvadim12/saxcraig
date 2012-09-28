//
//  ParsingHelper.h
//  saxcraig
//
//  Created by Vadim Khohlov on 9/27/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CategoryMatcher;
@interface ParsingHelper : NSObject

//these functions mutate title by cutting out the needed part from it:
- (NSString*) parseOutPlace:(NSString**)title;
- (NSString*) parseOutHousePrice:(NSString**)title;
- (NSString*) parseOutPrice:(NSString**)title;
- (NSString*) parseOutAge:(NSString**)title;
- (NSString*) parseOutPriceForTitle:(NSString**)title withMatcher:(CategoryMatcher*)matcher;

@end
