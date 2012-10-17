//
//  Stack.h
//  saxcraig
//
//  Created by Vadim Khohlov on 10/8/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack: NSObject {
    NSMutableArray* _data;
}

- (void) push: (id)item;
- (id) pop;
- (void) clear;
- (NSUInteger) count;
@end

