//
//  PLTwitterTableViewCell.m
//  CriticalMass
//
//  Created by Norman Sander on 03.01.15.
//  Copyright (c) 2015 Pokus Labs. All rights reserved.
//

#import "PLTwitterTableViewCell.h"

@implementation PLTwitterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5,5,40,40);
    float limgW =  self.imageView.image.size.width;
    if(limgW > 0) {
        self.textLabel.frame = CGRectMake(55,self.textLabel.frame.origin.y,self.textLabel.frame.size.width,self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(55,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width,self.detailTextLabel.frame.size.height);
    }
    self.imageView.layer.cornerRadius = CGRectGetHeight(self.imageView.frame)/2;
}

@end
