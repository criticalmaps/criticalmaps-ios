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
        _messages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)collectMessage:(NSString*) text {
    
    NSString *timestamp = [PLUtils getTimestamp];
    NSString *messageId = [NSString stringWithFormat:@"%@%@", _data.uid, timestamp];
    NSString *messageIdHashed = [messageId md5];
    
    PLChatObject *co = [[PLChatObject alloc] init];
    co.identifier = messageIdHashed;
    co.timestamp = timestamp;
    co.text = text;
    co.isActive = false;
    
    [_messages addObject:co];
    
    [_data request];
    
    // notify view
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChatMessagesReceived object:self];
    
}

- (void)addMessages: (NSDictionary*)messages {
    
    for(id key in messages){
        
        PLChatObject *message = [self getMessage:key];
        
        if(message){
            message.isActive = YES;
        }else{
            NSDictionary *message = [messages objectForKey:key];
            
            // create chat object
            PLChatObject *co = [[PLChatObject alloc] init];
            co.identifier = key;
            co.timestamp = [message objectForKey:@"timestamp"];
            co.text = [message objectForKey:@"message"];
            co.isActive = true;
            
            // fill dict
            [_messages addObject:co];
        }
    }
    
    // notify view
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChatMessagesReceived object:self];
}

- (PLChatObject*)getMessage:(NSString*)key {
    for (PLChatObject *co in _messages) {
        if ([co.identifier isEqualToString: key]) {
            return co;
        }
    }
    return nil;
}

- (NSArray*)getMessagesArray {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    
    for (PLChatObject *co in _messages) {
        
        if(!co.isActive){
            
            NSDictionary *messageJson = @ {
                @"timestamp": co.timestamp,
                @"identifier": co.identifier,
                @"text": co.text
            };
            [ret addObject:messageJson];
        }
    }
    return ret;
}


@end
