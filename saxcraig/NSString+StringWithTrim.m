//
//  NSString+StringWithTrim.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/8/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "NSString+StringWithTrim.h"

@implementation NSString (StringWithTrim)
- (NSString*)trimChars:(NSString*)trimmedChars {
    
    NSMutableCharacterSet* trimmCharset = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    if (nil != trimmedChars)
        [trimmCharset addCharactersInString:trimmedChars];
    
    return  [self stringByTrimmingCharactersInSet:trimmCharset];
}
@end
