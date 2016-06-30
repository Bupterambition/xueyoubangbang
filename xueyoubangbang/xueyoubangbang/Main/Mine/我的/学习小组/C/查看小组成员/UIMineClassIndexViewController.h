//
//  UIMineClassIndexViewController.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/20.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//  用于查看小组内的成员(不包括查看签到)

#import <UIKit/UIKit.h>
#import "MClass.h"
#import "StudentGroup.h"
#import "MineBaseViewController.h"
@interface UIMineClassIndexViewController : MineBaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) MClass *classinfo;
@property (nonatomic, strong) StudentGroup *groupinfo;
@end
