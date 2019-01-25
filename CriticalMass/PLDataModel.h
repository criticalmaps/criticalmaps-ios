//
//  PL.h
//  CriticalMass
//
//  Created by Norman Sander on 09.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "PLChatModel.h"

@class PLChatModel;

@interface PLDataModel : NSObject

@property (nonatomic, readonly) NSString *uid;
@property (nonatomic, assign) BOOL isBackroundMode;
@property (nonatomic, strong) PLChatModel *chatModel;

+ (id)sharedManager;
- (void)request;

@end
