//
//  DataMapLoaderTest.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/17/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import "DataMapLoaderTest.h"
#import "AFJSONRequestOperation.h"

@implementation DataMapLoaderTest

- (void) testLoad {
    NSLog(@"TEST LOAD");
    
    NSURL *url = [NSURL URLWithString:@"https://gowalla.com/users/mattt.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                    NSLog(@"SUCCESS");
            NSLog(@"IP Address: %@", [JSON valueForKeyPath:@"first_name"]);
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error ,id JSON) {
            NSLog(@"ERRRR");
            NSLog(@"ERROR %@", error);
        }];
    
    [operation start];
    while([operation isExecuting]) {
        NSLog(@"EXEC");
        sleep(1);
    }
    sleep(3);
    NSLog(@"Finished");
}

@end
