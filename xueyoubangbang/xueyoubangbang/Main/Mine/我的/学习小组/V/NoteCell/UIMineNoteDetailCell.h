//
//  UIHomeworkAddDetailCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/11.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHomeworkCheckDetailDelegate.h"
@class Note;
@interface UIMineNoteDetailCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, weak) id<UIHomeworkCheckDetailDelegate> checkDetailDelegate;
/**
 *  布置作业时使用
 *
 *  @param data 布置作业的单项数据
 */
- (void)loadItemData:(Note*)data;
@end
