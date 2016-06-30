//
//  UIHomeworkBottomView.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/7.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHomeworkBottomDelegate.h"
@interface UIHomeworkBottomView : UITableView
@property (nonatomic, weak) id<UIHomeworkBottomDelegate> homeworkBottomDelegate;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withTitle:(NSArray *)titleArray;
@end
