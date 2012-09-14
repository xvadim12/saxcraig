//
//  UnitTestHelper.h
//  saxcraig
//
//  Created by Vadim A. Khohlov on 9/12/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface UnitTestHelper : SenTestCase


- (NSString*)contentsOfFile:(NSString*)fileName;
@end
