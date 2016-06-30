//
//  MClass.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/28.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MClass.h"
@implementation MClass
+(MClass *)objectWithDictionary:(NSDictionary *)dic
{
    MClass *m = [JsonToModel objectFromDictionary:dic className:@"MClass"];
    m.class_name = [dic objectForKey:@"class_name"];
    m.class_type = dic[@"class_type"];
    m.Class = dic[@"class"];
    return m;
}

- (NSString *)class_name{
    if (_class_name == nil) {
        _class_name = @"未进入任何班级";
    }
    return _class_name;
}
@end
