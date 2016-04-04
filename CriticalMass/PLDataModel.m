//
//  PL.m
//  CriticalMass
//
//  Created by Norman Sander on 09.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLDataModel.h"
#import "PLConstants.h"
#import "PLUtils.h"
#import <NSString+Hashes.h>

@interface PLDataModel()

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) AFHTTPRequestOperationManager *operationManager;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) NSUInteger updateCount;
@property(nonatomic, assign) NSUInteger requestCount;
@property(nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation PLDataModel

+ (id)sharedManager {
    static PLDataModel *sharedMyManager = nil;
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

- (void)initUserId {
    NSString *deviceIdString = [[[UIDevice currentDevice] identifierForVendor]UUIDString];
    _uid = [NSString stringWithFormat:@"%@",[deviceIdString md5]];
}

- (void)initLocationManager {
    _locationManager = [[CLLocationManager alloc] init];
    
    // TODO: eventually automatic pause to help conserve power
    // _locationManager.pausesLocationUpdatesAutomatically = YES;
    
    // Apple: If GPS-level accuracy isn’t critical for your app and you don’t need continuous tracking, you can use the significant-change location service. It’s crucial that you use the significant-change location service correctly, because it wakes the system and your app at least every 15 minutes, even if no location changes have occurred, and it runs continuously until you stop it.
    
    // it’s recommended that you always call the locationServicesEnabled class method of CLLocationManager before attempting to start either the standard or significant-change location services

    
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
#ifdef DEBUG
    if(kDebugEnableTestLocation){
        CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:kTestLocationLatitude longitude:kTestLocationLongitude];
        _currentLocation = testLocation;
        [self performSelector:@selector(startRequestTimer) withObject:nil afterDelay:1.0];
    }else{
        [self enableGps];
    }
#else
    [self enableGps];
#endif
    
}

- (void)initHTTPRequestManager {
    _operationManager = [AFHTTPRequestOperationManager manager];
    _operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    _operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
}

- (void)startRequestTimer {
    DLog(@"startRequestTimer");
    
    [_timer invalidate];
    _timer = nil;
    [self request];
    _timer = [NSTimer scheduledTimerWithTimeInterval:kRequestRepeatTime target:self selector:@selector(request) userInfo:nil repeats:YES];
}

- (void)stopRequestTimer {
    DLog(@"stopRequestTimer");
    [_timer invalidate];
    _timer = nil;
}

- (void)request {
    _chatModel = [PLChatModel sharedManager];
    _requestCount++;
    
    NSString *longitudeString = _gpsEnabled ? [PLUtils locationdegrees2String:_currentLocation.coordinate.longitude] : @"";
    NSString *latitudeString = _gpsEnabled ? [PLUtils locationdegrees2String:_currentLocation.coordinate.latitude] : @"";
    NSString *requestUrl = kUrlService;
    
    NSDictionary *params = @ {
        @"device": _uid,
        @"location" : @{
                        @"longitude" :  longitudeString,
                        @"latitude" :  latitudeString
                        },
        @"messages": [_chatModel getMessagesArray]
    };
    
    DLog(@"Request Object: %@", params);
    
    [_operationManager POST:requestUrl parameters:params
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                        if (self.isBackroundMode) {
//                            [self extendBackgroundRunningTime];
//                        }
                        
                        DLog(@"Response Object: %@", responseObject);
                        _otherLocations = [responseObject objectForKey:@"locations"];
                        
                        NSDictionary *chatMessages = [responseObject objectForKey:@"chatMessages"];
                        [_chatModel addMessages: chatMessages];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPositionOthersChanged object:self];
                    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                        DLog(@"Error: %@", error);
                    }];
    
    if(_isBackroundMode && (_requestCount >= kMaxRequestsInBackground)){
        [self disableGps];
    }
}

- (void)enableGps {
    DLog(@"enableGps");
    _updateCount = 0;
    [self stopRequestTimer];
    [_locationManager startUpdatingLocation];
    _gpsEnabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGpsStateChanged object:self];
}

- (void)disableGps {
    DLog(@"disableGps");
    [_locationManager stopUpdatingLocation];
    [self stopRequestTimer];
    _gpsEnabled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGpsStateChanged object:self];
}

-(void)setIsBackroundMode:(BOOL)isBackroundMode {
    _isBackroundMode = isBackroundMode;
    
    if (_isBackroundMode) {
        [self extendBackgroundRunningTime];
//        [_locationManager startMonitoringSignificantLocationChanges];
        _requestCount = 0;
    } else {
//        [_locationManager stopMonitoringSignificantLocationChanges];
        if(!_gpsEnabled && _gpsEnabledUser){
            [self enableGps];
        }
    }
    DLog(@"backgroundMode: %@", _isBackroundMode ? @"YES" : @"NO");
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
    [self disableGps];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    DLog(@"didUpdateToLocation: %@", newLocation);
    
    _currentLocation = newLocation;
    
    if(_updateCount == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationInitialGpsDataReceived object:self];
        
#ifdef DEBUG
        if(!kDebugDisableHTTPRequests){
            [self performSelector:@selector(startRequestTimer) withObject:nil afterDelay:1.0];
        }
        
#else
        [self performSelector:@selector(startRequestTimer) withObject:nil afterDelay:1.0];
#endif
        
    }
    
    _updateCount++;
    
    if(_locality){
        return;
    }
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:_currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        CLPlacemark *placemark = placemarks.firstObject;
        _locality = [placemark locality];
    }];
}

- (void)extendBackgroundRunningTime {
    if (_backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
        // if we are in here, that means the background task is already running.
        // don't restart it.
        return;
    }
    NSLog(@"Attempting to extend background running time");
    
    __block Boolean self_terminate = YES;
    
    // Only 3 minutes of time to finish task
    _backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"TrackGPS" expirationHandler:^{
        DLog(@"Background task expired by iOS");
        if (self_terminate) {
            [[UIApplication sharedApplication] endBackgroundTask:_backgroundTaskIdentifier];
            _backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Background task started");
        
        while (true) {
            NSLog(@"background time remaining: %8.2f", [UIApplication sharedApplication].backgroundTimeRemaining);
            [NSThread sleepForTimeInterval:1];
        }
        
    });
}

@end
