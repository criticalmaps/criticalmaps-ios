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
        _allMessages = [[NSMutableDictionary alloc] init];
        _userMessages = [[NSMutableDictionary alloc] init];
        _allMessages = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)collectMessage:(NSString*) text {
    
    NSString *timestamp = [PLUtils getTimestamp];
    NSString *messageId = [NSString stringWithFormat:@"%@%@", _data.uid, timestamp];
    NSString *messageIdHashed = [messageId md5];
    
    PLChatObject *chatObject = [[PLChatObject alloc] init];
    chatObject.identifier = messageIdHashed;
    chatObject.timestamp = timestamp;
    chatObject.text = text;
    chatObject.isActive = false;
    
    [_userMessages setObject:chatObject forKey:messageIdHashed];
    
    
    
//    [_data request];
    
    // concat dicts
    [_allMessages addEntriesFromDictionary:_userMessages];
    
    // get keys
    _allKeys = [_allMessages allKeys];
    
    // notify view
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChatMessagesReceived object:self];
    
}

- (void)setMessages: (NSDictionary*)messages {
    
    //    [_remoteMessages removeAllObjects];
    
    for(id key in messages){
        
        NSDictionary *message = [messages objectForKey:key];
        
        // create chat object
        PLChatObject *co = [[PLChatObject alloc] init];
        co.identifier = key;
        co.timestamp = [message objectForKey:@"timestamp"];
        co.text = [message objectForKey:@"message"];
        co.isActive = true;
        
        // fill dict
        [_allMessages setObject:co forKey:key];
        
        // remove local messages
        [_userMessages removeObjectForKey:key];
    }
    
    // concat dicts
    [_allMessages addEntriesFromDictionary:_userMessages];
    
    // get keys
    _allKeys = [[_allMessages allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    // notify view
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChatMessagesReceived object:self];
}

- (NSArray*)getMessagesArray {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    
    for (id key in _userMessages) {
        
        PLChatObject *chatObject = [_userMessages objectForKey:key];
        
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
