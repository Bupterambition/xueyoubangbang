//
//  UIMineCell.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/28.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineCell.h"

@implementation UIMineCell

- (void)awakeFromNib {
    self.signupLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [self.signupLabel setTextColor:[UIColor greenColor]];
    [self.signupLabel setTextAlignment:NSTextAlignmentCenter];
    [self.signupLabel setFont:[UIFont systemFontOfSize:23]];
    [self.contentView addSubview:self.signupLabel];
    
}

-(void)layoutSubviews

{
    [super layoutSubviews];
    
    [self.imageView setFrame:CGRectMake(10, 8,self.frame.size.height - 2 * 8, self.frame.size.height - 2 * 8)];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = (self.frame.size.height - 2 * 8)/2;
    
    [self.textLabel setFrame:CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + 10, (self.frame.size.height - self.textLabel.frame.size.height - self.detailTextLabel.frame.size.height ) / 2, self.textLabel.frame.size.width, self.textLabel.frame.size.height)];
    
    [self.detailTextLabel setFrame:CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + 10, self.textLabel.frame.origin.y + self.textLabel.frame.size.height , self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height)];
    
    self.signupLabel.center = CGPointMake(self.contentView.frame.size.width-100, 5);
    self.signupLabel.text = @"已签到";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
