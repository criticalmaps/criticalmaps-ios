//
//  PLAnnotation.m
//  CriticalMass
//
//  Created by Norman Sander on 02.10.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLAnnotation.h"

@implementation PLAnnotation

@synthesize coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

@end
