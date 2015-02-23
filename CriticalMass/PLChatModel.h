//
//  PLChatModel.h
//  CriticalMaps
//
//  Created by Norman Sander on 19.02.15.
//  Copyright (c) 2015 Pokus Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "PLDataModel.h"

@interface PLChatModel : NSObject

@property(nonatomic, strong) AFHTTPRequestOperationManager *requestManager;
@property(nonatomic, strong) PLDataModel *data;
@property(nonatomic, strong) NSMutableArray *userMessages;
@property(nonatomic, strong) NSMutableArray *allMessages;

+ (id)sharedManager;
- (void)collectMessage:(NSString*) message;

@end
