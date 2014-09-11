//
//  PLFirstViewController.m
//  CriticalMass
//
//  Created by Norman Sander on 08.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLMapViewController.h"
#import "PLConstants.h"

@interface PLMapViewController ()

@end

@implementation PLMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initObserver];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _data = [PLData sharedManager];
    
    [self initMap];
}

- (void)initObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPositionChanged) name:kNotificationPositionChanged object:_data];
}

- (void)initMap
{
    // Mapkit with OSM overlay
    _map = [[MKMapView alloc]initWithFrame:self.view.bounds];
    _map.showsUserLocation = YES;
    _map.mapType = MKMapTypeHybrid;
    _map.delegate = self;
    
    NSString *template = kUrlTile;
    MKTileOverlay *overlay = [[MKTileOverlay alloc] initWithURLTemplate:template];
    overlay.canReplaceMapContent = YES;
    [_map addOverlay:overlay level:MKOverlayLevelAboveLabels];
    
    if(kDebug && kDebugEnableTestLocation){
        _map.centerCoordinate = CLLocationCoordinate2DMake(kTestLocationLatitude, kTestLocationLongitude);
    }
    
    [self.view addSubview:_map];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    _map = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationPositionChanged object:_data];
}

#pragma mark - Handler

- (void)onPositionChanged
{
    _map.centerCoordinate = _data.currentLocation.coordinate;
}

#pragma mark - Delegete methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    return nil;
}


@end
