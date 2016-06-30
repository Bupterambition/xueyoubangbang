//
//  QuestionAnswersNum.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/24.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectiorAnswerItemNumCellDelegate <NSObject>
/**
 *  改变选择题选项的数量
 *
 *  @param num 选择题选项数目
 */
- (void)didChangeSelectorAnswerItemNum:(NSInteger)num;
@end


@interface QuestionAnswersNum : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *answerNumLabel;
@property (weak, nonatomic) id<SelectiorAnswerItemNumCellDelegate> AnswerItemNumDelegate;
@end
