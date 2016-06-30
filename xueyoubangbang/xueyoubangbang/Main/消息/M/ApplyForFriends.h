//
//  ApplyForFriends.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
// 好友申请消息提醒

#import <Foundation/Foundation.h>

@interface ApplyForFriends : NSObject
@property (nonatomic, copy) NSString *applicant;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *remind_id;
@property (nonatomic, copy) NSString *remind_time;

@end
