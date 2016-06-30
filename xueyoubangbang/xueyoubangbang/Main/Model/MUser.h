//
//  MUser.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/24.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUser : NSObject
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *roles;  //1学生  2教师  3家长
@property (nonatomic,copy) NSString *header_photo;
@property (nonatomic,copy) NSString *keep_login;
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *schoolinfo;
@property (nonatomic,copy) NSString *qq;

+ (MUser *)objectWithDictionary:(NSDictionary *)dic;
@end
