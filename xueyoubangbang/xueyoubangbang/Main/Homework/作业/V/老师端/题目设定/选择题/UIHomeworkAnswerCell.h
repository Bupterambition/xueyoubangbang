//
//  UIHomeworkAnswer.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/10.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHomeworkAnswerDelegate.h"

@interface UIHomeworkAnswerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *answerItem;
@property (strong, nonatomic) NSIndexPath *currentPath;
@property (weak, nonatomic) id<UIHomeworkAnswerDelegate> answerDelegate;
/**
 *  载入单选题答案
 *
 *  @param answer 单选题答案
 */
- (void)loadSelector:(NSNumber*)answer;
/**
 *  隐藏多余选项
 *
 *  @param num 选项数目
 */
- (void)hideExcessButton:(NSInteger)num;
/**
 *  载入多选答案
 *
 *  @param answer 多选题答案
 */
- (void)loadMutilSelector:(NSArray*)answer;
@end
