//
//  ResultsProcessor.h
//  saxcraig
//
//  Created by Vadim Khohlov on 10/9/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultsProcessor : NSObject

//the request URL of the page that is being parsed
@property (nonatomic,retain) NSString* URL;

//the requestInfo object for some information dealing with request
@property (nonatomic,retain) NSDictionary* requestInfo;

/**
 Sublasses should provide the correct implemenation
 */
- (NSObject*) parseResultArray:(NSArray*)resultArray;

@end
