//
//  MUser.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/24.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MUser.h"

@implementation MUser
+ (MUser *)objectWithDictionary:(NSDictionary *)dic
{
    MUser *u = [JsonToModel objectFromDictionary:dic className:@"MUser"];
    return u;
}
- (NSString*)key{
    if (_key == nil) {
        _key = @"TEST";
    }
    return _key;
}
@end
