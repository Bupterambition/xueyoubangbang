//
//  HomeworkFinished.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//  学生完成作业时候的消息提醒

#import <Foundation/Foundation.h>

@interface HomeworkFinished : NSObject
@property (nonatomic, copy) NSString *subject_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *groupname;
@property (nonatomic, copy) NSString *groupid;
@property (nonatomic, copy) NSString *homeworkid;
@property (nonatomic, copy) NSString *finishnum;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *remind_id;
@property (nonatomic, copy) NSString *remind_time;
@property (nonatomic, copy) NSString *homework_id;
- (NSString*)getSubject;
@end
