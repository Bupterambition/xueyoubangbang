//
//  UIHomeworkMainCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/6.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHomeCellMainDelegate.h"
#import "NewHomeWork.h"
#import "MHomework.h"
@interface UIHomeworkMainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *finishTime;
@property (weak, nonatomic) IBOutlet UILabel *workDescription;
@property (weak, nonatomic) IBOutlet UILabel *dayleft;
@property (weak, nonatomic) IBOutlet UILabel *unfinishedCount;
@property (strong, nonatomic) NSIndexPath *currentIndex;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak , nonatomic) id<UIHomeCellMainDelegate> homeCellDelegate;
/**
 *  填充新版作业数据
 *
 *  @param home 新版本home数据
 */
- (void)loadNewHomeWorkData:(NewHomeWork *)home;
@end
