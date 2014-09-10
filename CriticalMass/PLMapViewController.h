//
//  PLFirstViewController.h
//  CriticalMass
//
//  Created by Norman Sander on 08.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PLData.h"

@interface PLMapViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic, strong) PLData *data;
@property (nonatomic, strong) MKMapView *map;

@end
