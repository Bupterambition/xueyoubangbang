//
//  MessageViewModel.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageViewModel : NSObject
/**
 *  消息相关接口
 *
 *  @param param    用户id：userid
 *  @param callback 列表回调
 */
+ (void)getMessageListWithParams:(NSDictionary *)param
                    withCallBack:(void (^)(id messageList))callback;
/**
 *  删除某一条消息
 *
 *  @param param    消息id：remindid
 *  @param callback 成功后回调
 */
+ (void)deleteMessageListWithParams:(NSDictionary *)param
                       withCallBack:(void (^)(BOOL success))callback;
/**
 *  获得申请好友的列表
 *
 *  @param param    用户id：userid
 页数：pageIndex
	每页条数：pageSize
 *  @param callback 回调member
 */
+ (void)getFriendListWithParams:(NSDictionary *)param
                   withCallBack:(void (^)(NSArray *friendlist))callback;
/**
 *  接受好友请求
 *
 *  @param param    userid:⽤用户id userkey:登录成功后台下发给客户端的key id:添加好友的id
 *  @param callback 回调
 */
+ (void)acceptFriendWithParams:(NSDictionary *)param
                  withCallBack:(void (^)(BOOL success))callback;
@end
