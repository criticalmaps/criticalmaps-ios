//
//  PLFirstViewController.m
//  CriticalMass
//
//  Created by Norman Sander on 08.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLMapViewController.h"
#import "PLConstants.h"
#import "PLUtils.h"
#import "PLInfoOverlayView.h"

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
    [self addButtonNavigate];
    
    _infoOverlay = [[PLInfoOverlayView alloc]initWithFrame:self.view.bounds];
    _infoOverlay.hidden = YES;
    [self.view addSubview:_infoOverlay];
}

- (void)initObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInitialGpsDataReceived) name:kNotificationInitialGpsDataReceived object:_data];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPositionOthersChanged) name:kNotificationPositionOthersChanged object:_data];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGpsStateChanged) name:kNotificationGpsStateChanged object:_data];
}

- (void)initMap
{
    _map = [[MKMapView alloc]initWithFrame:self.view.bounds];
    _map.zoomEnabled = YES;
    _map.mapType = MKMapTypeHybrid;
    _map.delegate = self;
    
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 10000, 10000);
    MKCoordinateRegion adjustedRegion = [_map regionThatFits:viewRegion];
    [_map setRegion:adjustedRegion animated:YES];
    _map.showsUserLocation = YES;
    
    /*
    // OpenStreetMap overlay
    NSString *template = kUrlTile;
    MKTileOverlay *overlay = [[MKTileOverlay alloc] initWithURLTemplate:template];
    overlay.canReplaceMapContent = YES;
    [_map addOverlay:overlay level:MKOverlayLevelAboveLabels];
     */
    
    if(kDebug && kDebugEnableTestLocation){
        _map.centerCoordinate = CLLocationCoordinate2DMake(kTestLocationLatitude, kTestLocationLongitude);
    }
    
    [self.view addSubview:_map];
}

- (void)addButtonNavigate
{
    UIButton *btnNavigate = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    btnNavigate.layer.cornerRadius = 3;
    [btnNavigate setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    btnNavigate.clipsToBounds = YES;
    btnNavigate.center = CGPointMake(self.view.frame.size.width-40, self.view.frame.size.height-80);
    [btnNavigate addTarget:self action:@selector(onClickNavigate) forControlEvents:UIControlEventTouchUpInside];
    [btnNavigate setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:btnNavigate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    _map = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationInitialGpsDataReceived object:_data];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationPositionOthersChanged object:_data];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationGpsStateChanged object:_data];
}

- (void)removeAllOthers
{
    NSInteger toRemoveCount = _map.annotations.count;
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
    for (id annotation in _map.annotations)
        if (annotation != _map.userLocation)
            [toRemove addObject:annotation];
    [_map removeAnnotations:toRemove];
}

- (void)addOther: (CLLocationCoordinate2D)coordinate
{
    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
    point.coordinate = coordinate;
    [_map addAnnotation:point];
}

#pragma mark - Handler

- (void)onInitialGpsDataReceived
{
    _map.centerCoordinate = _data.currentLocation.coordinate;
}

- (IBAction)onClickNavigate
{
    [_map setCenterCoordinate:_data.currentLocation.coordinate animated:YES];
}

- (void)onPositionOthersChanged
{
    [self removeAllOthers];
    
    for(id key in _data.otherLocations){
        NSDictionary *dict = [_data.otherLocations objectForKey:key];
        
        double latitude = [PLUtils string2Locationdegrees:[dict objectForKey:@"latitude"]];
        double longitude = [PLUtils string2Locationdegrees:[dict objectForKey:@"longitude"]];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        [self addOther:coordinate];
    }
}

- (void)onGpsStateChanged
{
    _infoOverlay.hidden = _data.gpsEnabled;
}

#pragma mark - Map delegate methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    return nil;
}

@end
