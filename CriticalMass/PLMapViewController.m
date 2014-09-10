//
//  PLFirstViewController.m
//  CriticalMass
//
//  Created by Norman Sander on 08.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLMapViewController.h"

@interface PLMapViewController ()

@end

@implementation PLMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _data = [PLData sharedManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPositionChanged) name:@"positionChanged" object:_data];
   
    _map = [[MKMapView alloc]initWithFrame:self.view.bounds];
    _map.showsUserLocation = YES;
    _map.mapType = MKMapTypeHybrid;
    _map.delegate = self;
    
    NSString *template = @"http://tile.openstreetmap.org/{z}/{x}/{y}.png";
    MKTileOverlay *overlay = [[MKTileOverlay alloc] initWithURLTemplate:template];
    overlay.canReplaceMapContent = YES;
    [_map addOverlay:overlay level:MKOverlayLevelAboveLabels];
        
    [self.view addSubview:_map];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    _map = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"positionChanged" object:_data];
}

- (void)onPositionChanged
{
    _map.centerCoordinate = CLLocationCoordinate2DMake(_data.currentLocation.coordinate.latitude, _data.currentLocation.coordinate.longitude);
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    return nil;
}


@end
