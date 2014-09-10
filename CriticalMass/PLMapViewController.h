//
//  PLFirstViewController.h
//  CriticalMass
//
//  Created by Norman Sander on 08.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox-iOS-SDK/Mapbox.h>
#import "PLData.h"


@interface PLMapViewController : UIViewController

@property PLData *data;
@property RMMapView *map;


@end
