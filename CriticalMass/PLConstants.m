//
//  PLConstants.m
//  CriticalMass
//
//  Created by Norman Sander on 11.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLConstants.h"

@implementation PLConstants

@end

// Debug
BOOL const kDebugEnableTestURL = NO;
BOOL const kDebugEnableTestLocation = NO;
BOOL const kDebugDisableHTTPRequests = NO;
BOOL const kDebugInitialTabIndex = 0;
BOOL const kDebugShowAppirater = NO;

// Urls
NSString *const kUrlService = @"https://api.criticalmaps.net/";

// Notifications
NSString *const kNotificationInitialGpsDataReceived = @"initialGpsDataReceived";
NSString *const kNotificationPositionOthersChanged = @"positionOthersChanged";
NSString *const kNotificationGpsStateChanged = @"gpsStateChanged";
NSString *const kNotificationChatMessagesReceived = @"chatMessagesReceived";

// Misc
NSTimeInterval const kRequestRepeatTime = 12.0;
NSUInteger const kMaxRequestsInBackground = 960;
double const kTestLocationLatitude = +52.50266880;
double const kTestLocationLongitude = +13.41227278;
NSString *const KTwitterQuery = @"#brexit";
