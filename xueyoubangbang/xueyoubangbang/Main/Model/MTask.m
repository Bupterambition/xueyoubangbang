//
//  MTask.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/28.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MTask.h"

@implementation MTask
+(MTask *)objectWithDictionary:(NSDictionary *)dic
{
    return [JsonToModel objectFromDictionary:dic className:@"MTask"];
}
@end
