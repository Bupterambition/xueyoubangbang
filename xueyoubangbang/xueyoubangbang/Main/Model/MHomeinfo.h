//
//  MHomeinfo.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/26.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHomeinfo : NSObject
@property (nonatomic,copy) NSString *roles;
@property (nonatomic,copy) NSString *info_username;
@property (nonatomic,assign) NSInteger lvlevel;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger progressValue;
@property (nonatomic,assign) NSInteger ranking;
@property (nonatomic,assign) NSInteger scoring;
@property (nonatomic,assign) NSInteger taskcnt;
@property (nonatomic,assign) NSInteger questioncnt;
@property (nonatomic,copy) NSString *info;
@property (nonatomic,copy) NSString *tipstitle;
@property (nonatomic,copy) NSString *tips;
@property (nonatomic,assign) NSInteger unfinishcnt;

+(MHomeinfo *)objectWithDictionary:(NSDictionary *)dic;
@end
