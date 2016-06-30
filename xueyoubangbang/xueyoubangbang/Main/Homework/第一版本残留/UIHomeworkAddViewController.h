//
//  UIHomeworkAddViewController.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/31.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UIPopCompleteDelegate<NSObject>
@optional
- (void)popComplete:(id)userinfo;

@end
@interface UIHomeworkAddViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) id<UIPopCompleteDelegate> popDelegate;

@end
