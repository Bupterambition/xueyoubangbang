//
//  UIHomeworkAddDetailCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/11.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHomeworkAddDetailDelegate.h"
@class NewHomeworkFileSend;
@interface UIHomeworkAddDetailCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, weak) id<UIHomeworkAddDetailDelegate> addDetailDelegate;
@property (weak, nonatomic) IBOutlet UILabel *itemNum;
/**
 *  布置作业时使用
 *
 *  @param data     布置作业的单项数据
 *  @param capacity 有多少作业，主要用于缓存数据
 */
- (void)loadItemData:(NewHomeworkFileSend*)data withCapacity:(NSInteger)capacity;
/**
 *  计算高度时使用
 *
 *  @param data     布置作业的单项数据
 */
- (void)loadItemDataForHeight:(NewHomeworkFileSend*)data;
@end
