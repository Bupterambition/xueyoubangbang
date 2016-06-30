//
//  MSubject.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/27.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MSubject.h"

@implementation MSubject

+(MSubject *)objectWithDictionary:(NSDictionary *)dic
{
    MSubject *m = [JsonToModel objectFromDictionary:dic className:@"MSubject"];
    return m;
}

+(MSubject *)objectWithId:(NSString *)subject_id name:(NSString *)subject_name nickname:(NSString *)nickname icon:(NSString *)icon
{
    MSubject *m = [[MSubject alloc] init];
    m.subject_id = subject_id;
    m.subject_name = subject_name;
    m.nickname = nickname;
    m.icon = icon;
    return m;
}

@end
