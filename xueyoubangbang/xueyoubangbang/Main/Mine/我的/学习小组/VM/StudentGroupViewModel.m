//
//  StudentGroupViewModel.m
//  xueyoubangbang
//
//  Created by Bob on 15/8/30.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineUrDefinel.h"
#import "StudentGroupViewModel.h"
#import "StudentGroupNetClient.h"
#import "MJExtension.h"

@implementation StudentGroupViewModel
+ (void)CreatStudentGroupwithparameters:(NSDictionary *)parameters
                           withCallBack:(void(^)(NSString * groupID,BOOL success))callBack{
    [StudentGroupNetClient StudentGroupGlobalPostHeader:CreatGroupUrl parameters:parameters withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callBack(dict[@"data"][@"groupid"],YES);
        }
        else{
            callBack(nil,NO);
        }
    }];
}

+ (void)GetStudentGroupListWithCallBack:(void(^)(NSArray *groups))callBack{
    [StudentGroupNetClient StudentGroupGlobalPostHeader:GetGroupList parameters:@{@"teacherid":[GlobalVar instance].user.userid} withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            NSArray *group_arr = [StudentGroup objectArrayWithKeyValuesArray:dict[@"data"][@"grouplist"]];
            callBack(group_arr);
        }
        else{
            callBack(nil);
        }
    }];
}
+ (void)GetGroupMemberListwithparameters:(NSDictionary *)parameters
                              withCallBack:(void(^)(NSArray *memberlist))callBack{
    [StudentGroupNetClient StudentGroupGlobalPostHeader:GetGroupMemberList parameters:parameters withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            if (dict[@"data"][@"memberlist"] == nil) {
                NSArray *members = [Member objectArrayWithKeyValuesArray:@[@{@"userid":@222,
                                                                             @"username":@"LJC",
                                                                             @"header_photo":@"https://ss0.baidu.com/73F1bjeh1BF3odCf/it/u=506601171,3669466822&fm=96&s=037053820BA0B3490ED5D4070300E0C1"}]];//dict[@"data"][@"memberlist"]];
                callBack(members);
            }
            else{
                NSArray *members = [Member objectArrayWithKeyValuesArray:dict[@"data"][@"memberlist"]];
                callBack(members);
            }
            
        }
        else{
            callBack(nil);
        }
    }];
}
+ (void)GetSignListwithparameters:(NSDictionary *)parameters
                       withCallBack:(void(^)(NSArray *memberlist))callBack{
    [StudentGroupNetClient StudentGroupGlobalPostHeader:GetSignList parameters:parameters withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            NSArray *members = [Member objectArrayWithKeyValuesArray:dict[@"data"][@"signinlist"]];
            callBack(members);
        }
        else{
            callBack(nil);
        }
    }];
}
+ (void)SignupInGroup:(NSDictionary *)parameters
         withCallBack:(void(^)(BOOL success))callBack{
    [StudentGroupNetClient StudentGroupGlobalPostHeader:SignInGroup parameters:parameters withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callBack(YES);
        }
        else{
            callBack(NO);
        }
    }];
}
+ (void)dissolveGroup:(NSDictionary *)parameters
         withCallBack:(void(^)(BOOL success))callBack{
    [StudentGroupNetClient StudentGroupGlobalPostHeader:DissolveGroup parameters:parameters withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callBack(YES);
        }
        else{
            callBack(NO);
        }
    }];
}
+ (void)modifyGroupName:(NSDictionary *)parameters
           withCallBack:(void(^)(BOOL success))callBack{
    [StudentGroupNetClient StudentGroupGlobalPostHeader:ChangeGroupName parameters:parameters withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callBack(YES);
        }
        else{
            callBack(NO);
        }
    }];
}
+ (void)operateGroupMember:(NSDictionary *)parameters
              withCallBack:(void(^)(BOOL success))callBack{
    [StudentGroupNetClient StudentGroupGlobalPostHeader:OperateGroupMember parameters:parameters withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callBack(YES);
        }
        else{
            callBack(NO);
        }
    }];
}

+ (void)setSignInAddress:(NSDictionary *)parameters
            withCallBack:(void (^)(BOOL))callBack{
    [StudentGroupNetClient StudentGroupGlobalPostHeader:SetSignInAddress parameters:parameters withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callBack(YES);
        }
        else{
            callBack(NO);
        }
    }];
}

+ (void)getSignInAddress:(NSDictionary *)parameters
            withCallBack:(void(^)(BOOL success,SignUpAdress *location))callBack{
    [StudentGroupNetClient StudentGroupGlobalPostHeader:GetSignInAddress parameters:parameters withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callBack(YES,[SignUpAdress objectWithKeyValues:dict[@"data"][@"addressinfo"]]);
        }
        else{
            callBack(NO,nil);
        }
    }];
}

+ (void)getKnowledgePointStatisticswithparameters:(NSDictionary *)parameters
                                     withCallBack:(void(^)(NSArray *memberlist))callBack{
    [StudentGroupNetClient StudentGroupGlobalPostHeader:knowledgepointstatistics parameters:parameters withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            NSArray *knowledgepointsid = [(NSString*)dict[@"data"][@"knowledgepointsid"] componentsSeparatedByString:@","];
            NSArray *knowledgepointsname = [(NSString*)dict[@"data"][@"knowledgepointsname"] componentsSeparatedByString:@","];
            NSArray *occurrencenumber = [(NSString*)dict[@"data"][@"occurrencenumber"] componentsSeparatedByString:@","];
            callBack(@[knowledgepointsid,knowledgepointsname,occurrencenumber]);
        }
        else{
            callBack(nil);
        }
    }];
}

+ (void)getAccuracystatisticswithparameters:(NSDictionary *)parameters
                               withCallBack:(void(^)(NSArray *dayaccstatistics))callBack{
    [StudentGroupNetClient StudentGroupGlobalPostHeader:GetAccuracystatistics parameters:parameters withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            NSArray *dayaccstatistics = [(NSString*)dict[@"data"][@"dayaccstatistics"] componentsSeparatedByString:@","];
            NSArray *validdays = [(NSString*)dict[@"data"][@"validdays"] componentsSeparatedByString:@","];
            callBack(@[dayaccstatistics,validdays]);
        }
        else{
            callBack(nil);
        }
    }];
}

+ (void)getNotelistswithparameters:(NSDictionary *)parameters
                      withCallBack:(void(^)(NSArray *noteList))callBack{
    [StudentGroupNetClient StudentGroupGlobalPostHeader:Getnotelists parameters:parameters withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            NSArray *notelist = [Note objectArrayWithKeyValuesArray:dict[@"data"][@"notelist"]];
            callBack(notelist);
        }
        else{
            callBack(nil);
        }
    }];
}

+ (void)deletenote:(NSDictionary *)parameters
      withCallBack:(void(^)(BOOL success))callBack{
    [StudentGroupNetClient StudentGroupGlobalPostHeader:Deletenote parameters:parameters withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callBack(YES);
        }
        else{
            callBack(NO);
        }
    }];
}
+ (void)addNoteWithParams:(NSDictionary *)param
          withFileDataArr:(NSArray *)fileDataArr
             withCallBack:(void(^)(BOOL success))callBack{
    [StudentGroupNetClient StudentGroupGlobalMultiPartPost:Addnote fileDataArr:fileDataArr parameters:param withCallBack:^(NSDictionary *rawData) {
        if(isUrlSuccess(rawData)){
            callBack(YES);
        }
        else{
            callBack(NO);
        }
    }];
}

+ (void)quiteGroup:(NSDictionary *)parameters
      withCallBack:(void(^)(BOOL success))callBack{
    [StudentGroupNetClient StudentGroupGlobalPostHeader:QuiteGroup parameters:parameters withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callBack(YES);
        }
        else{
            callBack(NO);
        }
    }];
}
@end
