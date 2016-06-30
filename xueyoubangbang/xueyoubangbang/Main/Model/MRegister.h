//
//  MRegister.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/27.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MRegister : NSObject
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *pwd;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *roles; //1学生  2教师  3家长
@property (nonatomic,copy) NSString *invitecode;
@property (nonatomic,copy) NSString *thirdid;

@property (nonatomic)       LoginType   logType;
//@property (nonatomic)  LoginType registerType;
- (NSDictionary *) toDictionary;
@end
