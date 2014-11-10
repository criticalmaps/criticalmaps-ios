//
//  PLLabel.m
//  CriticalMass
//
//  Created by Norman Sander on 10.11.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLLabel.h"

@implementation PLLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {10, 20, 10, 20};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
