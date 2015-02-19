//
//  PLMapViewController.h
//  CriticalMass
//
//  Created by Norman Sander on 08.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PLDataModel.h"
#import "PLInfoOverlayView.h"

@interface PLMapViewController : UIViewController<MKMapViewDelegate>{
    PLDataModel *_data;
    MKMapView *_map;
    UIView *_infoOverlay;
}


@end