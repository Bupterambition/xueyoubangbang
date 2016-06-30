//
//  NSMutableArray+Capacity.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/10.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Capacity)
/**
 *  用数字0填充NSMutableArray
 *
 *  @param numItems 容量
 *
 *  @return NSMutableArray
 */
+ (instancetype)initAnswerWithCapacity:(NSUInteger)numItems;
/**
 *  用可变数组填充NSMutableArray
 *
 *  @param numItems 容量
 *
 *  @return NSMutableArray
 */
+ (instancetype)initMutilAnswerWithCapacity:(NSUInteger)numItems;
@end
