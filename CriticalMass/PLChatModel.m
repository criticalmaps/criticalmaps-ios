//
//  PLChatModel.m
//  CriticalMaps
//
//  Created by Norman Sander on 19.02.15.
//  Copyright (c) 2015 Pokus Labs. All rights reserved.
//

#import "PLChatModel.h"
#import "PLUtils.h"
#import "PLConstants.h"

@implementation PLChatModel

+ (id)sharedManager {
    static PLChatModel *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        _data = [PLDataModel sharedManager];
        _userMessages = [[NSMutableArray alloc] init];
        [self initHTTPRequestManager];
    }
    return self;
}

- (void)initHTTPRequestManager {
    _requestManager = [AFHTTPRequestOperationManager manager];
    _requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    _requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
}

- (void)collectMessage:(NSString*) message {
    
    [_userMessages addObject:message];
    
    /*
    
    NSDictionary *messageJson = @ {
        @"timestamp": [PLUtils getTimestamp],
        @"identifier": _data.uid,
        @"text": message
    };
    
    NSDictionary *params = @ {
        @"messages": @[messageJson]
    };
    
    DLog(@"Request Object: %@", params);
    
    [kUrlService_requestManager POST:kUrlServiceChat parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DLog(@"JSON: %@", responseObject);
    }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
     }];
     */
}

@end
