//
//  NoneSelectorTableViewCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleStudentHomeworkAnswer.h"
@protocol NoneSelectorTableViewCellDelegate <NSObject>
@optional
/**
 *  点击展开图片进行编辑
 *
 *  @param index        当前现实的图片
 *  @param currentIndex 所在indexPath
 */
- (void)didToDetail:(NSInteger)index withIndex:(NSIndexPath*)currentIndex;
/**
 *  给当前题目打分
 *
 *  @param index        分数（对，错，半对）
 *  @param currentIndex 所在indexPath
 */
- (void)didGiveTheScore:(NSInteger)index withIndex:(NSIndexPath*)currentIndex;
@end

@interface NoneSelectorTableViewCell : UITableViewCell
@property (nonatomic, weak) id<NoneSelectorTableViewCellDelegate> noneseletorDelegate;
@property (nonatomic, strong) NSIndexPath *index;
/**
 *  老师查看学生答题信息
 *
 *  @param answer 图片信息，以,分割
 */
- (void)loadAnswerData:(NSString*)answer;
/**
 *  学生查看答题信息，不可以重新给分
 *
 *  @param answer 图片信息，以,分割
 *  @param score  当前项目分数
 */
- (void)loadAnswerDataForReview:(NSString*)answer withAnswerscore:(NSInteger)score;
/**
 *  老师复查答题信息，可以重新给分
 *
 *  @param answer 图片信息，以,分割
 *  @param score  当前项目分数
 *  @param preanswer 当前答案信息，用于保存老师批改后的原始图片
 */
- (void)loadAnswerDataForChecked:(NSString*)answer withAnswerscore:(NSInteger)score withPreAnswer:(SingleStudentHomeworkAnswer*)preanswer;
@end
