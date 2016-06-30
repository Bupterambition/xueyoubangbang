//
//  StudentHomeworkCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StudentHomeworkCellDelegate <NSObject>
/**
 *  查看批改
 *
 *  @param index 当前cell索引.用于获取homeworkid
 */
- (void)didToReview:(NSInteger)index;
@end
@class NewHomeWork;
@interface StudentHomeworkCell : UITableViewCell
@property (nonatomic, weak) id<StudentHomeworkCellDelegate> studentHomeworkCellDelegate;
@property (nonatomic, strong) NSIndexPath *index;
- (void)loadNewHomeWorkData:(NewHomeWork *)home;
@end
