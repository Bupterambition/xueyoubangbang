//
//  YYWeakProxy.h
//  xueyoubangbang
//
//  Created by Bob on 15/12/26.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

@interface YYWeakProxy : NSProxy

/**
 The proxy target.
 */
@property (nonatomic, weak, readonly) id target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
- (instancetype)initWithTarget:(id)target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
+ (instancetype)proxyWithTarget:(id)target;

@end
