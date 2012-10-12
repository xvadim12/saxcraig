//
//  PathItemEx.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/11/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "PathItemEx.h"

@implementation PathItemEx

@synthesize strDataMapPath;

- (id) initItem:(NSString*)tagName withAttributes:(NSDictionary*)attributes {
    if (self = [super initItem:tagName withAttributes:attributes]) {
        self.strDataMapPath = nil;
    }
    return self;
}

@end
