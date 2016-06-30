//
//  UIHomeworkAddDetailCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/11.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHomeworkCheckDetailDelegate.h"
@class NewHomeworkFileSend,NewHomeworkItem;
@interface UIHomeworkCheckDetailCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, weak) id<UIHomeworkCheckDetailDelegate> checkDetailDelegate;
@property (weak, nonatomic) IBOutlet UILabel *itemNum;

/**
 *  批改作业时使用
 *
 *  @param data 批改作业时的单项
 */
- (void)loadItemDataForCheck:(NewHomeworkItem*)data;
@end
