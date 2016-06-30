//
//  MClass.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/28.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface MClass : NSObject
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *class_info_id;
@property (nonatomic,copy) NSString *class_name;
@property (nonatomic,copy) NSString *grade;
@property (nonatomic,copy) NSString *iskedaibiao;
@property (nonatomic,copy) NSString *isshow;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *school;
@property (nonatomic,copy) NSString *subject;
@property (nonatomic,copy) NSString *Class;

//kelvinlu加上去的
@property (nonatomic,copy) NSString *class_type;

+(MClass *)objectWithDictionary:(NSDictionary *)dic;
@end
