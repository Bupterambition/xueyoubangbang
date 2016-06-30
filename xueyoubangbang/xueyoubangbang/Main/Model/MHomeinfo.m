//
//  MHomeinfo.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/26.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MHomeinfo.h"

@implementation MHomeinfo
+(MHomeinfo *)objectWithDictionary:(NSDictionary *)dic
{
    MHomeinfo *info = [JsonToModel objectFromDictionary:dic className:@"MHomeinfo"];
    info.progressValue = [[dic objectForKey:@"progress"] integerValue];
    info.scoring = [dic[@"scoring"]integerValue];
    info.unfinishcnt = [dic[@"unfinishcnt"]integerValue];
    return info;
}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"progressValue" : @"progress"
             };
}
@end
