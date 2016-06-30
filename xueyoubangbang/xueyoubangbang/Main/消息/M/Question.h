//
//  Question.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
// 互动圈消息提醒

#import <Foundation/Foundation.h>

@interface Question : NSObject
@property (nonatomic, copy) NSString *sendername;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *remind_id;
@property (nonatomic, copy) NSString *remind_time;
@end
