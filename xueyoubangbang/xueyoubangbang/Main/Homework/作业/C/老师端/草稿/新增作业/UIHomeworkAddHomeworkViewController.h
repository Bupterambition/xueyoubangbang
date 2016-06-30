//
//  UIHomeworkAddHomeworkViewController.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewHomeWorkSend;
@interface UIHomeworkAddHomeworkViewController : UIViewController
@property (nonatomic, assign) BOOL updateTable;
- (instancetype)initWithHomework:(NewHomeWorkSend*)homework withIndex:(NSIndexPath*)homeworkIndex;
@end
