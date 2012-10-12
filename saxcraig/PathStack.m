//
//  PathStack.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/8/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "NSString+StringWithTrim.h"
#import "PathItemEx.h"
#import "PathStack.h"

@implementation PathStack

- (id) pop {
    //in the path stack we don't need poped value. So, use more simple implementation without plaing with retain & autorelease
    [_data removeLastObject];
    return nil;
}

- (NSString*) findMatchingPathInArray:(NSDictionary*)allPaths {
    NSUInteger pathLen = [_data count];
    NSUInteger equalItemsCount, i;
    
    for(NSString* strPath in [allPaths allKeys]) {
        NSArray* path = [allPaths objectForKey:strPath];
        if([path count] == pathLen) {
            equalItemsCount = 0;
            for(i = 0; i < pathLen; i++)
                if ([[path objectAtIndex:i] isEqualToItem: [_data objectAtIndex:i]])
                    equalItemsCount++;
                else
                    break;
            if(equalItemsCount == pathLen)
                return strPath;
        }
    }
    
    return nil;
}

- (void) setMatchedPath:(NSString*)path {
    PathItemEx* lastItem = [_data lastObject];
    lastItem.strDataMapPath = path;
}

- (NSString*) currentMatchedPath {
    PathItemEx* lastItem = [_data lastObject];
    return lastItem.strDataMapPath;
}

@end