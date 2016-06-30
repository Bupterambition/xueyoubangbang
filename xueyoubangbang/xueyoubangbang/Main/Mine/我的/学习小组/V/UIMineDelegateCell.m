//
//  UIMineDelegateCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/5.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineDelegateCell.h"

@implementation UIMineDelegateCell

- (void)awakeFromNib {
    // Initialization code
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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
