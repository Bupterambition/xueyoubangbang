//
//  UIHomeworkViewModel.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/7.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIHomeworkViewModel : NSObject
/**
 *  获取作业列表(修改原接口)(老师/学生)
 *
 *  @param param    用户id：userid
	学习组id：groupid 用户为老师时不需发送该字段 学生必须发送
	页数：pageIndex
	每页条数：pageSize
 *  @param callback 作业回调
 */
+ (void)getHomeworkListWithParams:(NSDictionary *)param
                     withCallBack:(void (^)(NSArray *homeworkList))callback;
/**
 *  删除作业
 *
 *  @param param    用户id：teacherid,作业id：homeworkid
 *  @param callback 回调
 */
+ (void)deleteHomeworkWithParams:(NSDictionary *)param
                    withCallBack:(void(^)(BOOL success))callback;
/**
 *  修改提交时间
 *
 *  @param param    作业id：homeworkid
	老师id：teacherid
	新截止日期：deadline  格式 2015-08-18 22:15:30
 *  @param callback 回调成功，{"data":{"old":"2015-08-18 22:15:30","new":"2015-09-18 22:15:30"},"result":{"ret":"suc"}}
 */
+ (void)modifyHomeworkWithParams:(NSDictionary *)param
                    withCallBack:(void(^)(BOOL success,NSString *newdate))callback;

/**
 *  获取作业列表(原接口)(老师/学生)用于测试
 *
 *  @param param    用户id：userid
	学习组id：groupid 用户为老师时不需发送该字段 学生必须发送
	页数：pageIndex
	每页条数：pageSize
 *  @param callback 作业回调
 */
+ (void)getOldHomeworkListWithParams:(NSDictionary *)param
                     withCallBack:(void (^)(NSArray *homeworkList))callback;
/**
 *  作业项详情
 *
 *  @param param    作业id：homeworkid
 *  @param callBack 作业回调
 */
+ (void)getHomeworkDetailWithParams:(NSDictionary *)param
                       withCallBack:(void(^)(NSArray *homeWorkDetail,BOOL noNet))callBack;
/**
 *  布置作业
 *
 *  @param param       用户id：userid
	学习组id：groupid
	科目id：subjectid
	作业名称：title
	截止时间：submittime  格式 2015-09-01 00:00:00
	知识点id：knowledgepoints  格式 1,2,3,5
	作业内项数数量：itemcnt
 *  @param fileDataArr 第n项标题：item_n_title
	第n项描述：item_n_info
	第n项类型：item_n_type  0/1 简答题/选择题
 第n项答案：item_n_answer  该题type为1时，此字段输入选择题答案，否则不传或为空 格式 1,4,2,3  1为A…4为D
	第n项音频：item_n_audio
	第n项图片个数：item_n_imgscnt
	第n项第m个图片：item_n_img_m
 *  @param callBack    callback 回调
 */
+ (void)assignmentHomeworkWithParams:(NSDictionary *)param
                     withFileDataArr:(NSArray *)fileDataArr
                        withCallBack:(void(^)(BOOL success))callBack;
/**
 *  学生提交答案接口
 *
 *  @param param       学生id：userid
 作业内题目数量：itemnum
 *  @param fileDataArr 第n项题目id：item_n_id
	第n项题目类型：item_n_type       0为简答 1为选择
 第n项题目选择题答案：item_n_selectanswer 若题目为选择题则传送学生答案， 格式如下 1,3,4,2   代表A,C,D,B   小题间逗号分割
 第n项题目答案图片数量：item_n_imgscnt   题目为简答题时发送数量，选择题是为0
 第n项题目第m张图片：item_n_img_m
 *  @param callBack    callback 回调
 */
+ (void)finishHomeworkWithParams:(NSDictionary *)param
                 withFileDataArr:(NSArray *)fileDataArr
                    withCallBack:(void(^)(BOOL success))callBack;
/**
 *  获取知识点
 *
 *  @param param    科目id：subjectid
 年级：grade  1/2/3  小学/初中/高中
 *  @param callback callback
 */
+ (void)getKnowledgepointsListWithParams:(NSDictionary *)param
                        withCallBack:(void (^)(NSArray *knowledge))callback;
/**
 *  获取(已/未)做作业学生列表
 *
 *  @param param    作业id：homeworkid
	学生类别：finish 0/1 未完成作业学生/已完成作业学生
 *  @param callBack 返回值说明： homeworkchecked 0/1 完成作业学生作业未批改/已批改 未完成作业学生列表此字段无效
 */
+ (void)getFinishhomeworkListWithParams:(NSDictionary *)param
                           withCallBack:(void(^)(NSArray *Students))callBack;
/**
 *  获取学生作业答案
 *
 *  @param param    作业id：homeworkid
	学生id：userid
 *  @param callBack 回值说明：status 是否完成该条作业 0/1 未完成/已完成
 type 作业项是否为选择 0/1  不是选择/是选择
 selectanswer type=1时，选择题正误，0/1 错误/正确，type=0时无效
 answer type=0时，学生答案路径，多条照片路径逗号分割，type=1时无效
 answerscore 此时为无意义字段
 */
+ (void)getStudentanswerWithParams:(NSDictionary *)param
                      withCallBack:(void(^)(NSArray *Students))callBack;
/**
 *  查看学生作业批改
 *
 *  @param param    学生id：userid
 作业id：homeworkid
 *  @param callBack 返回值说明：status 是否完成该条作业 0/1 未完成/已完成
 type 作业项是否为选择 0/1  不是选择/是选择
 selectanswer type=1时，选择题正误，0/1 错误/正确，type=0时无效
 answer type=0时，学生答案路径，多条照片路径逗号分割，type=1时无效
 answerscore 简答题对错 0/1/2 错/半对/对
 studentselectanswer type=1时，学生所选选择题答案
 */
+ (void)getStudentReviewWithParams:(NSDictionary *)param
                      withCallBack:(void(^)(NSArray *Students))callBack;
/**
 *  批改作业
 *
 *  @param param    参数：
	作业id：homeworkid
	学生id：userid
 作业题目数量：itemnum
 第n项题目id：item_n_id
 第n项题目类型：item_n_type    0简答 1选择
 第n项题目答案评价：item_n_answer 简答题0、1、2分别代表错、半对、对，选择题发送对错序列，格式0,1,1,0
 评语：evaluate 字符串
 评价：rate 1a2b3c4d
 *  @param callback callback
 */
+ (void)checkHomeworkWithParams:(NSDictionary *)param
                   withCallBack:(void(^)(BOOL success))callback;
/**
 *  老师上传学生提交的答案图片
 *
 *  @param param       参数：
    学生ID：userid
	题目ID：homeworkitemid
    图片：picture
 
 *  @param fileDataArr 题目下的第N张图片：picture_order，接受数字，第一张为0,第二张为1，以此类推
 *  @param callBack    回调
 */
+ (void)uploadCorrectingPicWithParams:(NSDictionary *)param
                      withFileDataArr:(NSArray *)fileDataArr
                         withCallBack:(void(^)(BOOL success))callBack;

/**
 *  学生申请加入学校小组
 *
 *  @param param    学习组id：groupid，
 学生id：studentid
 *  @param callback callback
 */
+ (void)applyForGroupWithParams:(NSDictionary *)param
                   withCallBack:(void(^)(BOOL success,NSString *content))callback;

/**
 *  学生获取组列表
 *
 *  @param param    学生id：studentid
 *  @param callBack 学习小组
 */
+ (void)getstudentGroupListWithParams:(NSDictionary *)param
                         withCallBack:(void(^)(NSArray *Students))callBack;
/**
 *  获取学习小组详细信息(介绍/科目/名称/老师信息)
 *
 *  @param param    学习组id：groupid
 *  @param callBack 学习小组信息
 */
+ (void)getGroupInfoWithParams:(NSDictionary *)param
                  withCallBack:(void(^)(NSDictionary *groupInfo))callBack;
/**
 *  问题/互动圈列表
 *
 *  @param param    用户id：userid
 操作类型：type  1为我问的问题 0为别人向我提问
	页数：pageIndex
	每页数量：pageSize
 *  @param callBack 回调
 */
+ (void)getQuestionListWithParams:(NSDictionary *)param
                     withCallBack:(void(^)(NSArray *Students))callBack;
/**
 *  获取问题详情及回复列表
 *
 *  @param param    提出问题的用户id：userid
	问题id：id
 *  @param callBack 回调
 */
+ (void)getQuestionAnswerListWithParams:(NSDictionary *)param
                           withCallBack:(void(^)(NSArray *Students))callBack;
/**
 *  发起提问(修改原接口)
 *
 *  @param param       用户id：userid
	来源组id：formgroupid  0为好友，非0值为组id (从作业中提问带组id，直接提问置0)
 科目id：subjectid
	问题描述：item_info
	提问人id：toIds 多人时id之间用逗号’,’分割
	
	问题图片数量：item_imgscnt
	
 *  @param fileDataArr 问题音频：item_audio 规则同下图片
 *问题第n张图片：item_img_n 该提问若为作业项提问，该字段发送作业项中图片链接即可，如’http://cgi.sharingpop.cn/Public/Question/2015-09-07/12345.jpg’, 该提问若为新提问，该字段使用方法同发布作业
 * 返回值：
 *  @param callBack    回调yes
 */
+ (void)addquestionWithParams:(NSDictionary *)param
              withFileDataArr:(NSArray *)fileDataArr
                 withCallBack:(void(^)(BOOL success))callBack;
/**
 *  回复提问(修改原接口)
 *
 *  @param param       用户id：userid
	问题id：questionid
	回复描述：txt
 *  @param fileDataArr 回复音频：audio
	回复图片：item_img_1
 *  @param callBack    回调yes
 */
+ (void)addAnswerWithParams:(NSDictionary *)param
            withFileDataArr:(NSArray *)fileDataArr
               withCallBack:(void(^)(BOOL success))callBack;
/**
 *  一键提醒未交作业学生
 *
 *  @param param    作业id：homeworkid
 *  @param callBack studentunfinishlist 未提交作业学生id
 */
+ (void)QuickRemindWithParams:(NSDictionary *)param
                 withCallBack:(void(^)(BOOL success))callBack;
/**
 *  提醒未交作业学生(单人/多人)
 *
 *  @param param    作业id：homeworkid
	被提醒学生id：userid 提醒多人用逗号分隔 1,2,3
 *  @param callBack callBack studentunfinishlist 未提交作业学生id
 */
+ (void)RemindHomeworkSubmitWithParams:(NSDictionary *)param
                          withCallBack:(void(^)(BOOL success))callBack;
/**
 *  评价回答 踩/赞
 *
 *  @param param    评价人用户id：userid
	回答id：answerid
	评价类型：type    0踩1赞
 *  @param callBack newnum 踩/赞 操作过后 踩/赞 的数量
 */
+ (void)evaluateanswerWithParams:(NSDictionary *)param
                    withCallBack:(void(^)(BOOL success,NSInteger num))callBack;

@end
