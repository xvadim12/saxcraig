//
//  NSStringAdditions.h
//  saxcraig
//
//  Created by Vadim Khohlov on 9/27/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)
- (NSString*) stringByAppendingURLComponent:(NSString*)url;
- (NSString*) substringBetweenFirst:(NSString*)first andSecond:(NSString*)second;
@end
