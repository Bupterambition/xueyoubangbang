//
//  UnfinishedCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/27.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UnfinishedCell.h"
#import "CheckHomeWorkStudent.h"
@implementation UnfinishedCell

- (void)awakeFromNib {
    self.notificationBtn.layer.masksToBounds = YES;
    self.notificationBtn.layer.cornerRadius = 2;
    self.headerImg.layer.masksToBounds = YES;
    self.headerImg.layer.cornerRadius = 19;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)loadBtnState:(BOOL)ifNotification{
    if (ifNotification) {
        self.notificationBtn.layer.masksToBounds = NO;
        self.notificationBtn.selected = YES;
        [self.notificationBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.notificationBtn setTitle:@"已提醒" forState:UIControlStateNormal];
//        self.notificationBtn.enabled = NO;
    }
    else{
        self.notificationBtn.layer.masksToBounds = YES;
        self.notificationBtn.layer.cornerRadius = 2;
        self.notificationBtn.selected = NO;
        [self.notificationBtn setTitleColor:RGB(0,161,142) forState:UIControlStateNormal];
        [self.notificationBtn setTitle:@"提醒" forState:UIControlStateNormal];
//        self.notificationBtn.enabled = YES;//
    }
}
- (void)loadData:(CheckHomeWorkStudent*)data{
    self.nameLabel.text = data.username;
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg(data.headerphoto)] placeholderImage:DEFAULT_HEADER];
    [self loadBtnState:self.notificationBtn.tag == self.currentIndex.row +1 ?YES:NO];
}
- (IBAction)didTouchNotification:(UIButton *)sender {
    self.notificationBtn.tag = self.currentIndex.row +1;
    self.notificationBtn.layer.masksToBounds = NO;
    self.notificationBtn.selected = YES;
    [self.notificationBtn setTitle:@"已提醒" forState:UIControlStateNormal];
    [self.notificationBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    if ([self.unfinishedCellDelegate respondsToSelector:@selector(didTouchNotificationBtn:)]) {
//        sender.enabled = NO;//
        [self.unfinishedCellDelegate didTouchNotificationBtn:self.currentIndex];
    }
}
@end
