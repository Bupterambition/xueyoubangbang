//
//  CheckViewController.h
//  xueyoubangbang
//
//  Created by Bob on 15/8/30.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
// 查看签到

#import <UIKit/UIKit.h>
#import "MineBaseViewController.h"
#import "MClass.h"
#import "StudentGroup.h"
@interface UIMineCheckViewController: MineBaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) MClass *classinfo;
@property (nonatomic, strong) StudentGroup *groupinfo;
@property (nonatomic, strong) NSMutableArray *unsignupMembers;
@end
