//
//  PLChatObject.h
//  CriticalMaps
//
//  Created by Norman Sander on 25.02.15.
//  Copyright (c) 2015 Pokus Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLChatObject : NSData

@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL isActive;

@end
