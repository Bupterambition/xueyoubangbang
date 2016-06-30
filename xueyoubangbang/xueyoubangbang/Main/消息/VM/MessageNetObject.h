//
//  MessageNetObject.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface MessageNetObject : NSObject

@property AFHTTPRequestOperationManager* Netmanage;
+ (void)cancelRequest;
/**
 *  通用POST请求方法
 *
 *  @param urlStr     请求的url
 *  @param parameters 请求的字典
 *  @param callBack   回调函数（groupID代表产生的组id号，success为yes代表成功，no代表失败）
 */
+ (void) MessageGlobalPostHeader:(NSString *)urlStr
                      parameters:(NSDictionary *)parameters
                    withCallBack:(void(^)(NSDictionary * rawData))callBack;
@end
