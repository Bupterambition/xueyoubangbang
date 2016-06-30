//
//  UIHomeworkCheckDetailViewController.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CheckHomeWorkStudent;
@interface UIHomeworkCheckDetailViewController : UIViewController
/**
 *  用于给学生评论，因为需要回调
 */
@property (nonatomic, copy) NSString *evaluate;
- (instancetype)initWithHomework:(CheckHomeWorkStudent*)homeworkDetail;
@end
