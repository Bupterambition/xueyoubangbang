//
//  UIQuestionTableViewCell2.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQuestion.h"
@interface UIQuestionTableViewCell2 : UITableViewCell
@property (nonatomic,strong)    MQuestion   *question;

+ (CGFloat)cellHeight:(MQuestion *)question;
@end
