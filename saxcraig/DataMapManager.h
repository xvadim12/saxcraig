//
//  DataMapManager.h
//  saxcraig
//
//  Created by Vadim Khohlov on 10/16/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataMap;

typedef enum {
    DM_TYPE_SINGLE = 0,
    DM_TYPE_LIST,
    DM_TYPE_SEARCH
} DataMapType;

@interface DataMapManager : NSObject

+ (DataMapManager*)sharedMapManager;

- (DataMap*)dataMapWithType:(DataMapType)dataMapType;

- (void) startUpdateDataMapIfNeeded:(DataMapType)dataMapType;
- (BOOL) isUpdatingFinished;
@end
