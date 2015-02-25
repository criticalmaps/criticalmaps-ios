//
//  PL.h
//  CriticalMass
//
//  Created by Norman Sander on 09.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "PLChatModel.h"

@class PLChatModel;

@interface PLDataModel : NSObject<CLLocationManagerDelegate>{
    
    CLLocationManager *_locationManager;
    AFHTTPRequestOperationManager *_operationManager;
    NSTimer *_timer;
    NSUInteger _updateCount;
    NSUInteger _requestCount;
}

@property (nonatomic, readonly) NSString *uid;
@property (nonatomic, readonly) CLLocation *currentLocation;
@property (nonatomic, readonly) NSDictionary *otherLocations;
@property (nonatomic, readonly) BOOL gpsEnabled;
@property (nonatomic, assign) BOOL gpsEnabledUser;
@property (nonatomic, assign) BOOL isBackroundMode;
@property (nonatomic, strong) PLChatModel *chatModel;

+ (id)sharedManager;
- (void)enableGps;
- (void)disableGps;
- (void)request;

@end
