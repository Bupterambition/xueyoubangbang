//
//  MStudent.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/28.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MStudent : NSObject
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *roles;
@property (nonatomic,copy) NSString *header_photo;
@property (nonatomic,copy) NSString *pinYin;

+(MStudent *)objectWithDictionary:(NSDictionary *)dic;

@end
