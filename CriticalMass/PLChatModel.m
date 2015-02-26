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
#import "PLChatObject.h"
#import <NSString+Hashes.h>

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
    }
    return self;
}


- (void)collectMessage:(NSString*) message {
    
    PLChatObject *chatObject = [[PLChatObject alloc] init];
    
    NSString *timestamp = [PLUtils getTimestamp];
    NSString *messageId = [NSString stringWithFormat:@"%@%@", _data.uid, timestamp];
    
    chatObject.text = message;
    chatObject.identifier = [NSString stringWithFormat:@"%@",[messageId md5]];
    chatObject.timestamp = timestamp;
    
    [_userMessages addObject:chatObject];
    
    [_data request];
    
}

- (NSArray*)getMessagesArray {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    
    for (PLChatObject *chatObject in _userMessages) {
        NSDictionary *messageJson = @ {
            @"timestamp": chatObject.timestamp,
            @"identifier": chatObject.identifier,
            @"text": chatObject.text
        };
        [ret addObject:messageJson];
    }
    
    return ret;
}

@end
