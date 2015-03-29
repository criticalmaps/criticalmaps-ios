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
BOOL const kDebug = NO;
BOOL const kDebugEnableTestURL = NO;
BOOL const kDebugEnableTestLocation = NO;
BOOL const kDebugDisableHTTPRequests = NO;
BOOL const kDebugInitialTabIndex = 0;
BOOL const kDebugShowAppirater = NO;


// Urls
NSString *const kUrlService = @"http://api.criticalmaps.net/postv2";

// Notifications
NSString *const kNotificationInitialGpsDataReceived = @"initialGpsDataReceived";
NSString *const kNotificationPositionOthersChanged = @"positionOthersChanged";
NSString *const kNotificationGpsStateChanged = @"gpsStateChanged";
NSString *const kNotificationChatMessagesReceived = @"chatMessagesReceived";

// Misc
NSTimeInterval const kRequestRepeatTime = 30.0;
NSUInteger const kMaxRequestsInBackground = 480;
double const kTestLocationLatitude = +52.50266880;
double const kTestLocationLongitude = +13.41227278;