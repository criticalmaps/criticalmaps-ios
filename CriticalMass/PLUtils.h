//
//  PLUtils.h
//  CriticalMass
//
//  Created by Norman Sander on 12.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PLUtils : NSObject

+ (NSString *)locationdegrees2String:(double)degrees;
+ (double)string2Locationdegrees:(NSString*)string;
+ (NSString *)getTimestamp;

@end
