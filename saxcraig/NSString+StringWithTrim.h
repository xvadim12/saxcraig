//
//  NSString+StringWithTrim.h
//  saxcraig
//
//  Created by Vadim Khohlov on 10/8/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringWithTrim)
/**
 Trims from string whitespace and new lines. If trimmedChars is not nil also trims this chars
 */
- (NSString*)trimChars:(NSString*)trimmedChars;
@end
