//
//  MRegister.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/27.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MRegister.h"

@implementation MRegister
- (NSDictionary *) toDictionary
{
    return [JsonToModel dictionaryFromObject:self];
}
@end
