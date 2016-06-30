//
//  UIHomeworkDraftCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/7.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewHomeWorkSend.h"
#import "MHomework.h"
#import "UIHomeworkDraftDelegate.h"
@interface UIHomeworkDraftCell : UITableViewCell
@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, weak) id<UIHomeworkDraftDelegate> draftDelegate;
/**
 *  填充旧版作业
 *
 *  @param homework 作业数据
 */
- (void)loadOldHomework:(MHomework*)homework;
/**
 *  填充新班作业数据
 *
 *  @param homework 作业数据
 */
- (void)loadNewHomeWork:(NewHomeWorkSend*)homework;
@end
