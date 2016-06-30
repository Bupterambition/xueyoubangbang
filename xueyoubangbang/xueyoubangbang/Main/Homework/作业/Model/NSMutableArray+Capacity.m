//
//  NSMutableArray+Capacity.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/10.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "NSMutableArray+Capacity.h"

@implementation NSMutableArray (Capacity)

+ (instancetype)initAnswerWithCapacity:(NSUInteger)numItems{
    NSMutableArray *t = [self arrayWithCapacity:numItems];
    for (NSUInteger index = 0; index <numItems; index ++) {
        [t addObject:@0];
    }
    return t;
}
+ (instancetype)initMutilAnswerWithCapacity:(NSUInteger)numItems{
    NSMutableArray *t = [self arrayWithCapacity:numItems];
    for (NSUInteger index = 0; index <numItems; index ++) {
        [t addObject:[NSMutableArray array]];
    }
    return t;
}
@end
