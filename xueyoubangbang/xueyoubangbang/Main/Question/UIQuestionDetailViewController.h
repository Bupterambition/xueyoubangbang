//
//  UIQuestionDetailViewController.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQuestion.h"
@interface UIQuestionDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) MQuestion *question;
@property (nonatomic)   NSInteger questionType;
@end
