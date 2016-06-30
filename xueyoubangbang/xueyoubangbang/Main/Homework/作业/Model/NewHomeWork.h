//
//  NewHomeWork.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/7.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewHomeWork : NSObject
@property (nonatomic, copy) NSString *homework_id;
@property (nonatomic, copy) NSString *subject_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *owner_id;
@property (nonatomic, copy) NSString *inserttime;
@property (nonatomic, copy) NSString *submittime;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *Class;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *finishtime;
@property (nonatomic, copy) NSString *knowledgepointsid;
@property (nonatomic, copy) NSString *groupid;
@property (nonatomic, assign) NSInteger dayleft;
@property (nonatomic, copy) NSString *groupname;
@property (nonatomic, assign) NSInteger finishnum;
@property (nonatomic, copy) NSString *totalnum ;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *class_name;
@property (nonatomic, copy) NSString *subject_name;
@property (nonatomic, copy) NSString *subject_nick;
@property (nonatomic, assign) NSInteger ischecked;
@end
