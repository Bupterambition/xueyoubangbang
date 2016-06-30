//
//  UIMineNewStudentsJoinVC.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/1.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
// 处理新同学申请界面

#import <UIKit/UIKit.h>
#import "StudentGroup.h"
@interface UIMineNewStudentsJoinVC : UITableViewController
@property (nonatomic, strong) StudentGroup *groupinfo;
@property (nonatomic, copy) NSString *groupID;
@end
