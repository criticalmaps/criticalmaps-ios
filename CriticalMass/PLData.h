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

@interface PLData : NSObject<CLLocationManagerDelegate>{
    
    CLLocationManager *_locationManager;
    AFHTTPRequestOperationManager *_requestManager;
    NSTimer *_timer;
    NSString *_uid;
    NSUInteger _updateCount;
}

@property (nonatomic, readonly) CLLocation *currentLocation;
@property (nonatomic, readonly) NSDictionary *otherLocations;
@property (nonatomic, readonly) BOOL gpsEnabled;
@property (nonatomic, assign) BOOL gpsEnabledUser;

+ (id)sharedManager;
- (void)enableGps;
- (void)disableGps;
- (void)startRequestInterval;
- (void)stopRequestInterval;

@end
