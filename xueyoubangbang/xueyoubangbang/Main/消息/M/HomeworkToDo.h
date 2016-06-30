//
//  HomeworkToDo.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
// 对于学生端  是老师布置完作业后的消息提醒(学生端)

#import <Foundation/Foundation.h>

@interface HomeworkToDo : NSObject
@property (nonatomic, copy) NSString *subject_id;
@property (nonatomic, copy) NSString *groupname;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *remind_id;
@property (nonatomic, copy) NSString *groupid;
- (NSString*)getSubject;
@end
