//
//  DataMapLoader.h
//  saxcraig
//
//  Created by Vadim Khohlov on 10/24/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataMapLoader : NSObject

@property (nonatomic, retain) NSString* dataMapsDir;
@property (nonatomic, retain) NSError* lastError;

- (BOOL) isActualVersion:(NSString*)version ofDataMapFile:(NSString*)dataMapFile;
- (void) startLoadDataMapFile:(NSString*)dataMapFile;
- (BOOL) isFinished;
@end

NSString* dataMapsDirectory();
