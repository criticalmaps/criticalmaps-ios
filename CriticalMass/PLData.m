//
//  PL.m
//  CriticalMass
//
//  Created by Norman Sander on 09.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLData.h"
#import "PLConstants.h"
#import "PLUtils.h"
#import <NSString+Hashes.h>

@implementation PLData

+ (id)sharedManager {
    static PLData *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        _gpsEnabledUser = YES;
        
        [self initUserId];
        [self initLocationManager];
        [self initHTTPRequestManager];
        
    }
    return self;
}

- (void)initUserId
{
    NSString *deviceIdString = [[[UIDevice currentDevice] identifierForVendor]UUIDString];
    _uid = [NSString stringWithFormat:@"%@",[deviceIdString md5]];
}

- (void)initLocationManager
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    if(kDebug && kDebugEnableTestLocation){
        CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:kTestLocationLatitude longitude:kTestLocationLongitude];
        _currentLocation = testLocation;
    }else{
        [self enableGps];
    }
    
    
    if(!(kDebug && kDebugDisableHTTPRequests)){
        [self performSelector:@selector(startRequestInterval) withObject:nil afterDelay:1.0];
    }
}

- (void)initHTTPRequestManager
{
    _requestManager = [AFHTTPRequestOperationManager manager];
    _requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
}

- (void)startRequestInterval
{
    NSLog(@"startRequestInterval");
    [_timer invalidate];
    _timer = nil;
    
    [self onTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:kRequestRepeatTime target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)stopRequestInterval
{
    NSLog(@"stopRequestInterval");
    [_timer invalidate];
    _timer = nil;
}

- (void)request
{
    NSString *longitudeString = _gpsEnabled ? [PLUtils locationdegrees2String:_currentLocation.coordinate.longitude] : @"";
    NSString *latitudeString = _gpsEnabled ? [PLUtils locationdegrees2String:_currentLocation.coordinate.latitude] : @"";
    
    NSDictionary *parameters = @{@"device" : _uid, @"longitude" :  longitudeString, @"latitude" :  latitudeString};
    
    NSLog(@"request() parameters: %@", parameters);
    
    NSString *requestUrl = (kDebug && kDebugEnableTestURL) ? kUrlServiceTest : kUrlService;
    
    [_requestManager GET:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        _otherLocations = responseObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPositionOthersChanged object:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)enableGps{
    NSLog(@"enableGps");
    _updateCount = 0;
    [_locationManager startUpdatingLocation];
    _gpsEnabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGpsStateChanged object:self];
}

- (void)disableGps{
    NSLog(@"disableGps");
    [_locationManager stopUpdatingLocation];
    [self stopRequestInterval];
    _gpsEnabled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGpsStateChanged object:self];
}

#pragma mark - Handler
- (void)onTimer
{
    [self request];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
    [self disableGps];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    
    _currentLocation = newLocation;
    
    if (_currentLocation != nil) {
        NSLog(@"longitude: %.8f", _currentLocation.coordinate.longitude);
        NSLog(@"latitude: %.8f", _currentLocation.coordinate.latitude);
    }
    
    if(_updateCount == 0){
        [self startRequestInterval];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationInitialGpsDataReceived object:self];
    }
    _updateCount++;
}



@end
