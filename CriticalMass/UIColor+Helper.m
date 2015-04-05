//
//  UIColor+Helper.m
//  CriticalMaps
//
//  Created by Norman Sander on 05.04.15.
//  Copyright (c) 2015 Pokus Labs. All rights reserved.
//

#import "UIColor+Helper.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UIColor (Helper)

+ (UIColor *)magicColor {
    return UIColorFromRGB(0x028a68);
}


@end
