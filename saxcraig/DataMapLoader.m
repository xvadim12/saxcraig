//
//  DataMapLoader.m
//  saxcraig
//
//  Created by Vadim Khohlov on 10/24/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//
#import "AFHTTPRequestOperation.h"

#import "DataMapLoader.h"

NSString* const dataMapsURL = @"http://craigs-dms.s3.amazonaws.com/";
NSString* const versionHeader = @"x-amz-meta-dm-version";

@interface DataMapLoader ()

@property (nonatomic, retain) AFHTTPRequestOperation* loadOperation;
@property (nonatomic, retain) NSOperationQueue* loadOpsQueue;
@property (nonatomic, retain) NSString* tempFileName;
@property (nonatomic, retain) NSString* targetDataMapFile;

@end

@implementation DataMapLoader

@synthesize dataMapsDir;
@synthesize lastError;

@synthesize loadOperation;
@synthesize loadOpsQueue;

- (void) dealloc {
    
    self.dataMapsDir = nil;
    
	[super dealloc];
}

- (id) init {
	if ((self = [super init])) {
        self.dataMapsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        self.loadOperation = nil;
        self.loadOpsQueue = [[NSOperationQueue alloc] init];
        [self.loadOpsQueue setMaxConcurrentOperationCount:1];
	}
	return self;
}

- (BOOL) isActualVersion:(NSString*)version ofDataMapFile:(NSString*)dataMapFile {
    
    BOOL res = NO;
    
    NSURL *url = [NSURL URLWithString:[dataMapsURL stringByAppendingString:dataMapFile]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSHTTPURLResponse *response=nil;
    NSError *error=nil;
    
    [request setValue:@"HEAD" forKey:@"HTTPMethod"];
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (nil == error) {
        NSDictionary* headers = [response allHeaderFields];
        int newVersion = [[headers allKeys] containsObject:versionHeader] ? [[headers objectForKey:versionHeader] intValue] : 0;
        res = (BOOL)([version intValue] >= newVersion);
    }
    
    return res;
}


- (void) startLoadDataMapFile:(NSString*)dataMapFile {
    
    self.targetDataMapFile = dataMapFile;
    
    NSURL *url = [NSURL URLWithString:[dataMapsURL stringByAppendingString:dataMapFile]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    self.loadOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    self.tempFileName = [NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]];
    self.loadOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:self.tempFileName append:NO];
    
    [self.loadOperation setCompletionBlock:^{
        self.lastError = self.loadOperation.error;
        self.loadOperation = nil;
        
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        if (nil == self.lastError) {
            NSString* oldFile = [self.dataMapsDir stringByAppendingPathComponent: self.targetDataMapFile];
            //TODO: error processing
            [filemgr removeItemAtPath: oldFile error: nil];
            [filemgr moveItemAtURL: [NSURL fileURLWithPath: self.tempFileName] toURL: [NSURL fileURLWithPath: oldFile] error: nil];
        } else {
            [filemgr removeItemAtPath: self.tempFileName error: nil];
        }
        self.tempFileName = nil;
    }];

    [self.loadOpsQueue addOperation:self.loadOperation];
}


- (BOOL) isFinished {
    return 0 == [self.loadOpsQueue operationCount];
}

@end
