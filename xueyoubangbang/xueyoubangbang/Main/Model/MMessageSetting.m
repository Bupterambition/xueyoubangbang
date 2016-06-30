//
//  MMessageSetting.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/5.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MMessageSetting.h"

@implementation MMessageSetting

- (id)init
{
    self = [super init];
    if(self)
    {
        _homeworkTime = [NSMutableArray array];
    }
    return self;
}

+(MMessageSetting *)objectiWithDictionary:(NSDictionary *)dic
{
    MMessageSetting *m = [JsonToModel objectFromDictionary:dic className:@"MMessageSetting"];
    m.homeworkTime = [NSMutableArray arrayWithArray:[dic objectForKey:@"homeworkTime"]];
    return m;
}

- (NSDictionary *)toDictionary
{
    return [JsonToModel dictionaryFromObject:self];
}

@end
