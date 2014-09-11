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
    NSTimer *_timer;
    NSString *_uid;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, readonly) CLLocation *currentLocation;
@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

+ (id)sharedManager;


@end
