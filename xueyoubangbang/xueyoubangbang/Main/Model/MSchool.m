//
//  MSchool.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/25.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MSchool.h"

@implementation MSchool
+(MSchool *)objectWithDictionary:(NSDictionary *)dic
{
    return [JsonToModel objectFromDictionary:dic className:@"MSchool"];
}
@end
