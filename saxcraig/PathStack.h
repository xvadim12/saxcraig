//
//  PathStack.h
//  saxcraig
//
//  Created by Vadim Khohlov on 10/8/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "Stack.h"

/**
 Simple stack for saving current path in the file
 */
@interface PathStack: Stack

- (NSArray*) findMatchingPathInArray:(NSArray*)allPaths;
@end