//
//  MTask.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/28.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTask : NSObject
@property (nonatomic,copy) NSString *task_id;
@property (nonatomic,copy) NSString *taskname;
@property (nonatomic,copy) NSString *needtime;
@property (nonatomic,copy) NSString *realtime;
@property (nonatomic,copy) NSString *from_user_id;
@property (nonatomic,copy) NSString *from_roles_id;
@property (nonatomic,copy) NSString *from_roles_name;
@property (nonatomic,copy) NSString *inserttime;
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *jifen;
@property (nonatomic,copy) NSString *homeworkid;
@property (nonatomic,copy) NSString *subject_id;

+(MTask *)objectWithDictionary:(NSDictionary *)dic;
@end
