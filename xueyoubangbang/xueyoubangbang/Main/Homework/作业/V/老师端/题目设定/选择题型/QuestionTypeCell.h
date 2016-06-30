//
//  QuestionTypeCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/24.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QuestionTypeDelegate <NSObject>
/**
 *  改变题型
 *
 *  @param num 题型（0代表解答，1代表单选，2代表多选）
 */
- (void)didTouchQuestionType:(NSInteger)num;
@end


@interface QuestionTypeCell : UITableViewCell
@property (weak, nonatomic) id<QuestionTypeDelegate> questionTypeDelegate;
@end
