//
//  StudentGroupViewModel.h
//  xueyoubangbang
//
//  Created by Bob on 15/8/30.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIMineModels.h"
#import "MBProgressHUD+MJ.h"
@interface StudentGroupViewModel : NSObject
/**
 *  创建学习小组
 *
 *  @param parameters 请求参数
 *  @param callBack   回调块（groupID代表产生的组id号，success为yes代表成功，no代表失败）
 */
+ (void)CreatStudentGroupwithparameters:(NSDictionary *)parameters
                           withCallBack:(void(^)(NSString * groupID,BOOL success))callBack;
/**
 *  获取学习小组列表
 *
 *  @param callBack   回调块
 */
+ (void)GetStudentGroupListWithCallBack:(void(^)(NSArray *groups))callBack;
/**
 *  获取组内成员列表(申请/已加入)
 *
 *  @param parameters 请求参数（学习组id：groupid，是否已被接受：accept(0/1 申请列表/成员列表)）
 *  @param callBack   回调快,返回成员列表的Model数组
 */
+ (void)GetGroupMemberListwithparameters:(NSDictionary *)parameters
                              withCallBack:(void(^)(NSArray *memberlist))callBack;
/**
 *  获取已签到列表
 *
 *  @param parameters 参数：学习组id：groupid，签到日期：date (0000-00-00)
 *  @param callBack   回调快,返回签到成员列表的Model数组
 */
+ (void)GetSignListwithparameters:(NSDictionary *)parameters
                              withCallBack:(void(^)(NSArray *memberlist))callBack;
/**
 *  签到接口(签到有效/取消签到)
 *
 *  @param parameters 学习组id：groupid，签到日期：date (0000-00-00) 用户id：userid，用户名称：username，签到类型：type (0为签到 1为取消签到)
 *  @param callBack   回调快,表示签到成功与否
 */
+ (void)SignupInGroup:(NSDictionary *)parameters
         withCallBack:(void(^)(BOOL success))callBack;
/**
 *  解散学习组
 *
 *  @param parameters 学习组id：groupid，创建该组的老师id：teacherid
 *  @param callBack   回调快,表示解散成功与否
 */
+ (void)dissolveGroup:(NSDictionary *)parameters
         withCallBack:(void(^)(BOOL success))callBack;
/**
 *  修改学习小组名字
 *
 *  @param parameters 用户id：userid，学习组id：groupid，新组名称：groupname
 *  @param callBack   回调块,表示修改是否成功
 */
+ (void)modifyGroupName:(NSDictionary *)parameters
           withCallBack:(void(^)(BOOL success))callBack;
/**
 *  操作组人员(接受申请/移除组内学生)
 *
 *  @param parameters 用户id：studentid  批量删除用户时格式为 1,2,3 多个id间,分割     不提供批量添加
                  是否已被接受：accept(0/1 申请列表/成员列表)
                     学习组id：groupid
                     操作类型：operate(0/1 删除/增加)
 *  @param callBack   回调块,表示操作是否成功
 */
+ (void)operateGroupMember:(NSDictionary *)parameters
              withCallBack:(void(^)(BOOL success))callBack;
/**
 *  设置签到位置
 *
 *  @param parameters 
 *  学习组id：groupid，
 *  老师id：teacherid
 *  纬度：latitude
 *  经度：atitude
 *  地址：address
 *  @param callBack   回调块,表示操作是否成功
 */
+ (void)setSignInAddress:(NSDictionary *)parameters
            withCallBack:(void(^)(BOOL success))callBack;
/**
 *  获取签到位置信息
 *
 *  @param parameters 学习组id：groupid
 *  @param callBack   回调快返回经纬度信息以及地址
 */
+ (void)getSignInAddress:(NSDictionary *)parameters
            withCallBack:(void(^)(BOOL success,SignUpAdress *location))callBack;
/**
 *  统计知识点
 *
 *  @param parameters 学习组id：groupid
                        月份：month
                        年份：year
 *  @param callBack   返回值说明：knowledgepointid 知识点队列[0]
                                knowledgepointsname 知识点名字［1］
                                Occurrencenumber 知识点队列对应的出现次数队列[2]
 */
+ (void)getKnowledgePointStatisticswithparameters:(NSDictionary *)parameters
                                     withCallBack:(void(^)(NSArray *memberlist))callBack;

/**
 *  统计错误率
 *
 *  @param parameters 参数：
	学生id：studentid
 学习组id：groupid
	月份：month
 年份：year
 *  @param callBack   返回当月错误率证书
 */
+ (void)getAccuracystatisticswithparameters:(NSDictionary *)parameters
                                     withCallBack:(void(^)(NSArray *dayaccstatistics))callBack;
/**
 *  获得笔记本列表
 *
 *  @param parameters 用户id：userid
	页数：pageIndex
	每页条数：pageSize
 *  @param callBack   callback
 */
+ (void)getNotelistswithparameters:(NSDictionary *)parameters
                      withCallBack:(void(^)(NSArray *noteList))callBack;
/**
 *  删除笔记
 *
 *  @param parameters 用户id：userid
 笔记id：noteid
 *  @param callBack   deletenoteid 被删除的笔记的id（不需要）
 */
+ (void)deletenote:(NSDictionary *)parameters
            withCallBack:(void(^)(BOOL success))callBack;
/**
 *  添加笔记本
 *
 *  @param param       参数：
	用户id：userid
 科目id：subjectid
	问题描述：item_info
	问题图片数量：item_imgscnt
 *  @param fileDataArr
	问题第n张图片：item_img_n；
 
	问题音频：item_audio 规则同下图片
 *  @param callBack    回调
 */
+ (void)addNoteWithParams:(NSDictionary *)param
          withFileDataArr:(NSArray *)fileDataArr
             withCallBack:(void(^)(BOOL success))callBack;
/**
 *  退出小组
 *
 *  @param parameters 学习组id：groupid，
                        学生id：studentid
 *  @param callBack   回调
 */
+ (void)quiteGroup:(NSDictionary *)parameters
      withCallBack:(void(^)(BOOL success))callBack;
@end
