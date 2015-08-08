//
//  PLInfoOverlayView.m
//  CriticalMass
//
//  Created by Norman Sander on 18.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLInfoOverlayView.h"

@implementation PLInfoOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.text = NSLocalizedString(@"map.layer.info", nil);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}

@end
