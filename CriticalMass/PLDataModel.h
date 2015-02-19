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

@interface PLDataModel : NSObject<CLLocationManagerDelegate>{
    
    CLLocationManager *_locationManager;
    AFHTTPRequestOperationManager *_requestManager;
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

+ (id)sharedManager;
- (void)enableGps;
- (void)disableGps;

@end
