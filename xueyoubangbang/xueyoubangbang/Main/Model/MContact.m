//
//  MContact.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/27.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MContact.h"

@implementation MContact
+(MContact *)objectWithDictionary:(NSDictionary *)dic
{
    return [JsonToModel objectFromDictionary:dic className:@"MContact"];
}
@end
