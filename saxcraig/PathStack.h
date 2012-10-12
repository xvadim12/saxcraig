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

- (NSString*) findMatchingPathInArray:(NSDictionary*)allPaths;

/**
 Sets data map path to path item on the top of stack
 */
- (void) setMatchedPath:(NSString*)path;
/**
 Returns data map path associated with path item from the top of stack
 */
- (NSString*) currentMatchedPath;
@end