//
//  Stack.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/8/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "Stack.h"

@implementation Stack

- (id)init; {
    if (self = [super init])
        _data = [NSMutableArray array];
    return self;
}

- (void) dealloc {
	_data = nil;
    
	[super dealloc];
}

- (void) push: (id)item {
    [_data addObject:item];
}

- (id) pop {
    id obj = nil;
    if ([_data count] != 0)
    {
        obj = [[[_data lastObject] retain] autorelease];
        [_data removeLastObject];
    }
    return obj;
}

- (void) clear {
    [_data removeAllObjects];
}
@end
