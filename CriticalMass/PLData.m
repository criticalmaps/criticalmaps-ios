//
//  PL.m
//  CriticalMass
//
//  Created by Norman Sander on 09.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLData.h"

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
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
        
        _requestManager = [AFHTTPRequestOperationManager manager];
        _requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    }
    return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    _currentLocation = newLocation;
    
    if (_currentLocation != nil) {
        NSLog(@"longitude: %.8f", _currentLocation.coordinate.longitude);
        NSLog(@"latitude: %.8f", _currentLocation.coordinate.latitude);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"positionChanged" object:self];
    }
}

@end






/*
 TODO
 
 NSString *longitudeString = [NSString stringWithFormat:@"%.8f", _currentLocation.coordinate.longitude];
 NSString *latitudeString = [NSString stringWithFormat:@"%.8f", _currentLocation.coordinate.latitude];
 
 NSDictionary *parameters = @{@"device" : @"1234", @"longitude" :  longitudeString, @"latitude" :  latitudeString};
 
 NSLog(@"parameters: %@", parameters);
 
 NSString *requestUrl = @"http://criticalmass.stephanlindauer.de/get.php";
 
 
 [_requestManager GET:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSLog(@"JSON: %@", responseObject);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"Error: %@", error);
 }];
 */
