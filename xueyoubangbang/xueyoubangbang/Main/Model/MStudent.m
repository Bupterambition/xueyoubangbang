//
//  MStudent.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/28.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MStudent.h"

@implementation MStudent
+(MStudent *)objectWithDictionary:(NSDictionary *)dic
{
    return [JsonToModel objectFromDictionary:dic className:@"MStudent"];
}
@end
