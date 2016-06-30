//
//  UIContactTableViewCell.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/27.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIContactTableViewCell.h"

@implementation UIContactTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews

{
    [super layoutSubviews];
    
    [self.imageView setFrame:CGRectMake(10, 8,self.frame.size.height - 16, self.frame.size.height - 16)];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = CGRectGetWidth(self.imageView.frame)/2;
    [self.textLabel setFrame:CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + 10, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.frame.size.height)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
