//
//  MSchool.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/25.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSchool : NSObject
@property (nonatomic,copy) NSString *school_id;
@property (nonatomic,copy) NSString *school_name;
@property (nonatomic,copy) NSString *city_id;

+(MSchool *)objectWithDictionary:(NSDictionary *)dic;
@end
