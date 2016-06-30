//
//  UIHomeworkAddDetailCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/11.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHomeworkStudentDetailCellDelegate.h"
@class NewHomeworkFileSend,NewHomeworkItem;
@interface UIHomeworkStudentDetailCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, weak) id<UIHomeworkStudentDetailDelegate> checkDetailDelegate;
@property (nonatomic, weak) IBOutlet UILabel *itemNum;
@property (nonatomic, strong) NSData *cellAudio;
/**
 *  批改作业时使用
 *
 *  @param data 批改作业时的单项
 */
- (void)loadItemDataForCheck:(NewHomeworkItem*)data;
@end
