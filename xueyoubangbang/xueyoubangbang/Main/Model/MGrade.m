//
//  MGrade.m
//  xueyoubangbang
//
//  Created by kelvinlu on 15/6/22.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MGrade.h"

@implementation MGrade
+(MGrade *)objectWithDictionary:(NSDictionary *)dic
{
    MGrade *m = [JsonToModel objectFromDictionary:dic className:@"MGrade"];
    return m;
}

@end
