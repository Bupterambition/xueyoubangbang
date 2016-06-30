//
//  QuestionAnswerNumCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/24.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QuestionAnswerNumCellDelegate <NSObject>
/**
 *  改变选择题的数量
 *
 *  @param num 当前选择题数量
 */
- (void)didChangeSelectorNum:(NSInteger)num;
@end

@interface QuestionAnswerNumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *questionNumLabel;
@property (weak, nonatomic) id<QuestionAnswerNumCellDelegate> questionAnswerNumDelegate;
@end
