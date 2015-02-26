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
        _userMessages = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void)collectMessage:(NSString*) text {
    
    NSString *timestamp = [PLUtils getTimestamp];
    NSString *messageId = [NSString stringWithFormat:@"%@%@", _data.uid, timestamp];
    NSString *messageIdHashed = [messageId md5];
    
//    NSDictionary *message = @{
//                             @"text": text,
//                             @"timestamp": timestamp
//                             };
    
    PLChatObject *chatObject = [[PLChatObject alloc] init];
    chatObject.identifier = messageIdHashed;
    chatObject.timestamp = timestamp;
    chatObject.text = text;
    
    [_userMessages setObject:chatObject forKey:messageIdHashed];
    
    [_data request];
    
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

- (void)setMessages: (NSDictionary*)messages {

    _allMessages = messages;
    
    //remove local messages when id is approved
    for(id key in messages){
        [_userMessages removeObjectForKey:key];
    }
}
@end
