//
//  PLUtils.m
//  CriticalMass
//
//  Created by Norman Sander on 12.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLUtils.h"


@implementation PLUtils

+(NSString*)locationdegrees2String:(double)degrees
{
    return [[NSString stringWithFormat:@"%.06f", degrees] stringByReplacingOccurrencesOfString:@"." withString:@""];
}

+(double)string2Locationdegrees:(NSString*)string{
    return (double)([string floatValue]/1000000);
}

+(NSString*)getTimestamp
{
    return [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
}

@end
