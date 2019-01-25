//
//  PL.m
//  CriticalMass
//
//  Created by Norman Sander on 09.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLDataModel.h"
#import "PLConstants.h"
#import "PLUtils.h"
#import <NSString+Hashes.h>

@interface PLDataModel()

@property(nonatomic, strong) AFHTTPSessionManager *operationManager;
@property(nonatomic, assign) NSUInteger updateCount;
@property(nonatomic, assign) NSUInteger requestCount;

@end

@implementation PLDataModel

+ (id)sharedManager {
    static PLDataModel *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        [self initUserId];
        [self initHTTPRequestManager];
    }
    return self;
}

- (void)initUserId {
    NSString *deviceIdString = [[[UIDevice currentDevice] identifierForVendor]UUIDString];
    _uid = [NSString stringWithFormat:@"%@",[deviceIdString md5]];
}

- (void)initHTTPRequestManager {
    _operationManager = [AFHTTPSessionManager manager];
    _operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    _operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
}

- (void)request {
    _chatModel = [PLChatModel sharedManager];
    _requestCount++;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:_uid forKey:@"device"];
    [params setObject:[_chatModel getMessagesArray] forKey:@"messages"];
    
    DLog(@"Request Object: %@", params);
    
    [_operationManager POST:kUrlService parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        DLog(@"Response Object: %@", responseObject);
        
        NSDictionary *chatMessages = [responseObject objectForKey:@"chatMessages"];
        [self->_chatModel addMessages: chatMessages];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        DLog(@"Error: %@", error);
    }];
    
}

-(void)setIsBackroundMode:(BOOL)isBackroundMode {
    _isBackroundMode = isBackroundMode;
    
    if (_isBackroundMode) {
        _requestCount = 0;
    }
    DLog(@"backgroundMode: %@", _isBackroundMode ? @"YES" : @"NO");
}
@end
