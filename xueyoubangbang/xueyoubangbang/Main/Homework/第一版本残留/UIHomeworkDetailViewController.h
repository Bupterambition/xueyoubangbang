//
//  UIHomeworkDetailViewController.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHomework.h"
@interface UIHomeworkDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) MHomework *homework;
@property (nonatomic,copy) NSString *homeworkid;
@end
