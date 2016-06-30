//
//  UIHomeworkEditViewController.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/10.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewHomeWorkSend.h"
#import "NewHomeworkFileSend.h"

@interface UIHomeworkEditViewController : UIViewController
@property (nonatomic, strong) NewHomeWorkSend *baseHome;
@property (nonatomic, strong) NewHomeworkFileSend *baseHomeInfo;
@end
