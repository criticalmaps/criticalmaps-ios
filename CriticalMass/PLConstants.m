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
BOOL const kDebug = YES;
BOOL const kDebugEnableTestURL = NO;
BOOL const kDebugEnableTestLocation = YES;
BOOL const kDebugDisableHTTPRequests = YES;
BOOL const kDebugInitialTabIndex = 4;

// Urls
NSString *const kUrlService = @"http://api.criticalmaps.net/get";
NSString *const kUrlServiceTest = @"http://api.criticalmaps.net/test";

// Notifications
NSString *const kNotificationInitialGpsDataReceived = @"initialGpsDataReceived";
NSString *const kNotificationPositionOthersChanged = @"positionOthersChanged";
NSString *const kNotificationGpsStateChanged = @"gpsStateChanged";

// Misc
NSTimeInterval const kRequestRepeatTime = 30.0;
NSUInteger const kMaxRequestsInBackground = 480;
double const kTestLocationLatitude = +52.50266880;
double const kTestLocationLongitude = +13.41227278;
NSString *const kTwitterQuery = @"#criticalmaps";