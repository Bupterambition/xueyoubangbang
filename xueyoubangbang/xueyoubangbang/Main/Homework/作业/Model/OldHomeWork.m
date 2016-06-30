//
//  OldHomeWork.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "OldHomeWork.h"

@implementation OldHomeWork
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"itemlist" : @"OldHomeworkItem"
             };
}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"Class" : @"class"
             };
}
@end
