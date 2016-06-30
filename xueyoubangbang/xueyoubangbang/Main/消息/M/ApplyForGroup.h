//
//  ApplyForGroup.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//  学生申请加入群组时候的消息提醒(老师端)

#import <Foundation/Foundation.h>

@interface ApplyForGroup : NSObject
@property (nonatomic, copy) NSString *groupname;
@property (nonatomic, copy) NSString *groupid;
@property (nonatomic, copy) NSString *studentid;
@property (nonatomic, copy) NSString *studentname;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *remind_id;
@property (nonatomic, copy) NSString *remind_time;
@end
