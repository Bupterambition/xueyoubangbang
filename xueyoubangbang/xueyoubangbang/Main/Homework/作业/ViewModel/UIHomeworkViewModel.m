//
//  UIHomeworkViewModel.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/7.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkViewModel.h"
#import "UIHomeworkModels.h"
#import "UIHomeworkUrlDefine.h"
#import "UIHomeworkNetClient.h"
#import "UCZProgressView.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "YTKKeyValueStore.h"
#import "NSDate+Format.h"
@implementation UIHomeworkViewModel
extern BOOL notNetStatus;
+ (void)getHomeworkListWithParams:(NSDictionary *)param
                     withCallBack:(void (^)(NSArray *))callback{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:GetHomeworkList parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"Xueyoubangbang.db"];
            NSString *tableName;
            if (ifRoleTeacher) {
                tableName = [NSString stringWithFormat:@"HomeworkList_For_Teacher_%@_%@",param[@"pageIndex"],param[@"userid"]];
            }
            else{
                tableName = [NSString stringWithFormat:@"HomeworkList_For_Student_%@_%@_%@",param[@"groupid"],param[@"pageIndex"],param[@"userid"]];
            }
            // 创建名为user_table的表，如果已存在，则忽略该操作
            [store createTableWithName:tableName];
            [store putObject:rawData withId:param[@"pageIndex"] intoTable:tableName];
            NSArray *homeworkList = [NewHomeWork objectArrayWithKeyValuesArray:rawData[@"data"][@"homeworklist"]];
            callback(homeworkList);
        }
        else if (notNetStatus){
            YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"Xueyoubangbang.db"];
            NSString *tableName;
            if (ifRoleTeacher) {
                tableName = [NSString stringWithFormat:@"HomeworkList_For_Teacher_%@_%@",param[@"pageIndex"],param[@"userid"]];
            }
            else{
                tableName = [NSString stringWithFormat:@"HomeworkList_For_Student_%@_%@_%@",param[@"groupid"],param[@"pageIndex"],param[@"userid"]];
            }
            // 创建名为user_table的表，如果已存在，则忽略该操作
            [store createTableWithName:tableName];
            rawData = [store getObjectById:param[@"pageIndex"] fromTable:tableName];
            if (isUrlSuccess(rawData)) {
                NSArray *homeworkList = [NewHomeWork objectArrayWithKeyValuesArray:rawData[@"data"][@"homeworklist"]];
                callback(homeworkList);
            }
            else{
                callback(nil);
            }
        }
        else{
            callback(nil);
        }
    }];
}

+ (void)deleteHomeworkWithParams:(NSDictionary *)param
                    withCallBack:(void(^)(BOOL success))callback{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:Deletehomework parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callback(YES);
        }
        else{
            callback(NO);
        }
    }];
}

+ (void)modifyHomeworkWithParams:(NSDictionary *)param
                    withCallBack:(void(^)(BOOL success,NSString *newdate))callback{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:Modifyhomework parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callback(YES,rawData[@"data"][@"new"]);
        }
        else{
            callback(NO,nil);
        }
    }];
}

+ (void)getOldHomeworkListWithParams:(NSDictionary *)param
                        withCallBack:(void (^)(NSArray *homeworkList))callback{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:kUrlHomeworkList parameters:param withCallBack:^(NSDictionary *rawData) {
        if(isUrlSuccess(rawData)){
            NSArray *homwWorks = [OldHomeWork objectArrayWithKeyValuesArray:rawData[@"list"]];
            callback(homwWorks);
        }
    }];
}

+ (void)getHomeworkDetailWithParams:(NSDictionary *)param
                       withCallBack:(void(^)(NSArray *homeWorkDetail,BOOL noNet))callBack{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:GetHomeworkDetail parameters:param withCallBack:^(NSDictionary *rawData) {
        if(isUrlSuccess(rawData)){
            YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"Xueyoubangbang.db"];
            NSString *tableName = @"Homework_Detail_Teacher";
            // 创建名为user_table的表，如果已存在，则忽略该操作
            [store createTableWithName:tableName];
            [store putObject:rawData withId:param[@"homeworkid"] intoTable:tableName];
            NewHomeworkInfo *homeworkinfo = [NewHomeworkInfo objectWithKeyValues:rawData[@"data"][@"homeworkinfo"]];
            NSArray *homeworkItems = [NewHomeworkItem objectArrayWithKeyValuesArray:rawData[@"data"][@"homeworkitemlist"]];
            callBack(@[homeworkinfo,homeworkItems],NO);
        }
        else if (notNetStatus) {
            YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"Xueyoubangbang.db"];
            NSString *tableName = @"Homework_Detail_Teacher";
            // 创建名为user_table的表，如果已存在，则忽略该操作
            [store createTableWithName:tableName];
            rawData = [store getObjectById:param[@"homeworkid"] fromTable:tableName];
            if (isUrlSuccess(rawData)) {
                NewHomeworkInfo *homeworkinfo = [NewHomeworkInfo objectWithKeyValues:rawData[@"data"][@"homeworkinfo"]];
                NSArray *homeworkItems = [NewHomeworkItem objectArrayWithKeyValuesArray:rawData[@"data"][@"homeworkitemlist"]];
                callBack(@[homeworkinfo,homeworkItems],NO);
            }
            else{
                callBack(nil,YES);
            }
        }
        else{
            callBack(nil,NO);
        }
    }];
}


+ (void)assignmentHomeworkWithParams:(NSDictionary *)param
                     withFileDataArr:(NSArray *)fileDataArr
                        withCallBack:(void(^)(BOOL success))callBack{
    [UIHomeworkNetClient HomeWorkGlobalMultiPartPost:Assignmenthomework fileDataArr:fileDataArr parameters:param withCallBack:^(NSDictionary *rawData) {
        if(isUrlSuccess(rawData)){
            callBack(YES);
        }
        else{
            callBack(NO);
        }
    }];
}

+ (void)getKnowledgepointsListWithParams:(NSDictionary *)param
                            withCallBack:(void (^)(NSArray *knowledge))callback{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:Getknowledgepointslist parameters:param withCallBack:^(NSDictionary *rawData) {
        if(isUrlSuccess(rawData)){
            NSMutableArray *trueArray = [NSMutableArray array];
            NSArray *test = [KnowLedgePoint objectArrayWithKeyValuesArray:rawData[@"data"][@"knowledgepointslist"]];
            [test enumerateObjectsUsingBlock:^(KnowLedgePoint* obj, NSUInteger idx, BOOL *stop) {
                [trueArray addObject:obj];
                if ([obj.hasnextlevel isEqualToString:@"1"]) {
                    [trueArray addObjectsFromArray:obj.subknowledgepointslist];
                }
            }];
            callback(trueArray);
        }
        else{
            callback(nil);
        }
    }];
}

+ (void)getFinishhomeworkListWithParams:(NSDictionary *)param
                           withCallBack:(void(^)(NSArray *Students))callBack{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:Getfinishhomeworklist parameters:param withCallBack:^(NSDictionary *rawData) {
        if(isUrlSuccess(rawData)){
            NSArray *students = [CheckHomeWorkStudent objectArrayWithKeyValuesArray:rawData[@"data"][@"studentlist"]];
            callBack(students);
        }
        else{
            callBack(nil);
        }
    }];
}

+ (void)finishHomeworkWithParams:(NSDictionary *)param
                 withFileDataArr:(NSArray *)fileDataArr
                    withCallBack:(void(^)(BOOL success))callBack{
    [UIHomeworkNetClient HomeWorkGlobalMultiPartPost:Finishhomework
                                         fileDataArr:fileDataArr
                                          parameters:param
                                        withCallBack:^(NSDictionary *rawData)
    {
        if(isUrlSuccess(rawData)){
            callBack(YES);
        }
        else{
            callBack(NO);
        }
    }];
}

+ (void)getStudentanswerWithParams:(NSDictionary *)param
                      withCallBack:(void(^)(NSArray *Students))callBack{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:Getstudentanswer parameters:param withCallBack:^(NSDictionary *rawData) {
        if(isUrlSuccess(rawData)){
            SingleStudentHomeworkInfo *homeworkinfo = [SingleStudentHomeworkInfo objectWithKeyValues:rawData[@"data"][@"homeworkinfo"]];
            NSArray *homeworkItems = [SingleStudentHomeworkAnswer objectArrayWithKeyValuesArray:rawData[@"data"][@"homeworkitemlist"]];
            callBack(@[homeworkinfo,homeworkItems]);
        }
    }];
}

+ (void)getStudentReviewWithParams:(NSDictionary *)param
                      withCallBack:(void(^)(NSArray *Students))callBack{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:Gethomeworkcheck parameters:param withCallBack:^(NSDictionary *rawData) {
        if(isUrlSuccess(rawData)){
            SingleStudentHomeworkInfo *homeworkinfo = [SingleStudentHomeworkInfo objectWithKeyValues:rawData[@"data"][@"homeworkinfo"]];
            NSArray *homeworkItems = [SingleStudentHomeworkAnswer objectArrayWithKeyValuesArray:rawData[@"data"][@"homeworkitemlist"]];
            callBack(@[homeworkinfo,homeworkItems]);
        }
        else{
            callBack(nil);
        }
    }];
}

+ (void)checkHomeworkWithParams:(NSDictionary *)param
                   withCallBack:(void(^)(BOOL success))callback{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:Checkhomeworkanswer parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callback(YES);
        }
        else{
            callback(NO);
        }
    }];
}

+ (void)uploadCorrectingPicWithParams:(NSDictionary *)param
                      withFileDataArr:(NSArray *)fileDataArr
                         withCallBack:(void(^)(BOOL success))callBack{
    [UIHomeworkNetClient HomeWorkGlobalMultiPartPost:UploadCorrectPic fileDataArr:fileDataArr parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callBack(YES);
        }
        else{
            callBack(NO);
        }
    }];
}

+ (void)applyForGroupWithParams:(NSDictionary *)param
                   withCallBack:(void(^)(BOOL success,NSString *content))callback{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:applyForGroup parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callback(YES,nil);
        }
        else{
            callback(NO,rawData[@"result"][@"errorMessage"]);
        }
    }];
}

+ (void)getstudentGroupListWithParams:(NSDictionary *)param
                         withCallBack:(void(^)(NSArray *Students))callBack{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:studentGroupList parameters:param withCallBack:^(NSDictionary *dict) {
        if ([dict[@"result"][@"ret"] isEqualToString:@"suc"]) {
            YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"Xueyoubangbang.db"];
            NSString *tableName = @"student_Group_List";
            // 创建名为user_table的表，如果已存在，则忽略该操作
            [store createTableWithName:tableName];
            [store putObject:dict withId:param[@"studentid"] intoTable:tableName];
            NSArray *group_arr = [StudentGroup objectArrayWithKeyValuesArray:dict[@"data"][@"grouplist"]];
            callBack(group_arr);
        }
        else if (notNetStatus) {
            YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"Xueyoubangbang.db"];
            NSString *tableName = @"student_Group_List";
            // 创建名为user_table的表，如果已存在，则忽略该操作
            [store createTableWithName:tableName];
            dict = [store getObjectById:param[@"studentid"] fromTable:tableName];
            if (isUrlSuccess(dict)) {
                NSArray *group_arr = [StudentGroup objectArrayWithKeyValuesArray:dict[@"data"][@"grouplist"]];
                callBack(group_arr);
            }
            else{
                callBack(nil);
            }
        }
        else{
            callBack(nil);
        }
    }];
}
+ (void)getGroupInfoWithParams:(NSDictionary *)param
                  withCallBack:(void(^)(NSDictionary *groupInfo))callBack{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:getGroupInfo parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callBack(rawData[@"data"]);
        }
        else{
            callBack(nil);
        }
        
    }];
}
+ (void)getQuestionListWithParams:(NSDictionary *)param
                     withCallBack:(void(^)(NSArray *Students))callBack{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:GetQuestionList parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            NSArray *questions = [MQuestion objectArrayWithKeyValuesArray:rawData[@"data"][@"questionlist"]];
            callBack(questions);
        }
        else{
            callBack(nil);
        }
        
    }];
}
+ (void)getQuestionAnswerListWithParams:(NSDictionary *)param
                           withCallBack:(void(^)(NSArray *Students))callBack{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:GetQuestion parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            MQuestion *quesinfo = [MQuestion objectWithKeyValues:rawData[@"data"][@"questioninfo"]];
            NSArray *answerList = [AnswerObject objectArrayWithKeyValuesArray:rawData[@"data"][@"answerlist"]];
            callBack(@[quesinfo,answerList]);
        }
        else{
            callBack(nil);
        }
        
    }];
}
+ (void)QuickRemindWithParams:(NSDictionary *)param
                 withCallBack:(void(^)(BOOL success))callBack{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:QuickRemindHomeworkSubmit parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callBack(YES);
        }
        else{
            callBack(NO);
        }
        
    }];
}
+ (void)RemindHomeworkSubmitWithParams:(NSDictionary *)param
                          withCallBack:(void(^)(BOOL success))callBack{
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:remindHomeworkSubmit parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callBack(YES);
        }
        else{
            callBack(NO);
        }
        
    }];
}
+ (void)evaluateanswerWithParams:(NSDictionary *)param
                    withCallBack:(void(^)(BOOL success,NSInteger num))callBack{//Evaluateanswer
    [UIHomeworkNetClient HomeWorkGlobalPostHeader:Evaluateanswer parameters:param withCallBack:^(NSDictionary *rawData) {
        if ([rawData[@"result"][@"ret"] isEqualToString:@"suc"]) {
            callBack(YES,[rawData[@"data"][@"newnum"] integerValue]);
        }
        else{
            callBack(NO,0);
        }
        
    }];
}
+ (void)addquestionWithParams:(NSDictionary *)param
              withFileDataArr:(NSArray *)fileDataArr
                 withCallBack:(void(^)(BOOL success))callBack{
    [UIHomeworkNetClient HomeWorkGlobalMultiPartPost:AddQuestion
                                         fileDataArr:fileDataArr
                                          parameters:param
                                        withCallBack:^(NSDictionary *rawData)
     {
         if(isUrlSuccess(rawData)){
             callBack(YES);
         }
         else{
             callBack(NO);
         }
     }];
}
+ (void)addAnswerWithParams:(NSDictionary *)param
            withFileDataArr:(NSArray *)fileDataArr
               withCallBack:(void(^)(BOOL success))callBack{
    [UIHomeworkNetClient HomeWorkGlobalMultiPartPost:AddAnswer
                                         fileDataArr:fileDataArr
                                          parameters:param
                                        withCallBack:^(NSDictionary *rawData)
     {
         if(isUrlSuccess(rawData)){
             callBack(YES);
         }
         else{
             callBack(NO);
         }
     }];
}
@end
