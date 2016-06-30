//
//  MessageViewModel.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MessageViewModel.h"
#import "MessageNetObject.h"
#import "UCZProgressView.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "UIMessageModels.h"
#import "UIMessageUrlDefine.h"
@implementation MessageViewModel
+ (void)getMessageListWithParams:(NSDictionary *)param
                    withCallBack:(void (^)(id messageList))callback{
    [MessageNetObject MessageGlobalPostHeader:GetMessageList parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            MessageObject *messagelist = [MessageObject objectWithKeyValues:rawData[@"data"]];
            callback(messagelist);
        }
        else{
            callback(nil);
        }
    }];
}
+ (void)deleteMessageListWithParams:(NSDictionary *)param
                       withCallBack:(void (^)(BOOL success))callback{
    [MessageNetObject MessageGlobalPostHeader:DeleteMessage parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callback(YES);
        }
        else{
            callback(NO);
        }
    }];
}
+ (void)getFriendListWithParams:(NSDictionary *)param
                   withCallBack:(void (^)(NSArray *friendlist))callback{
    [MessageNetObject MessageGlobalPostHeader:GetFriendAddList parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            NSArray *friendArray = [Member objectArrayWithKeyValuesArray:rawData[@"data"][@"requestlist"]];
            callback(friendArray);
        }
        else{
            callback(nil);
        }
    }];
}
+ (void)acceptFriendWithParams:(NSDictionary *)param
                  withCallBack:(void (^)(BOOL success))callback{
    [MessageNetObject MessageGlobalPostHeader:AcceptFriendAdd parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callback(YES);
        }
        else{
            callback(NO);
        }
    }];
}
@end
