//
//  UIHomeworkUrlDefine.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/7.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#ifndef xueyoubangbang_UIHomeworkUrlDefine_h
#define xueyoubangbang_UIHomeworkUrlDefine_h
#define kUrlHeads                @"http://cgi.sharingpop.cn/"
#define kUrlTest                @"http://10.210.110.72"
#define NewUrlString(url)       [NSString stringWithFormat:@"%@%@",kUrlHeads,url]

#define GetHomeworkList         NewUrlString(@"/index.php/home/homework/gethomeworklist")//获取作业列表(修改原接口)(老师/学生)
#define Deletehomework          NewUrlString(@"/index.php/home/homework/deletehomework")//.删除作业(修改原接口)
#define Modifyhomework          NewUrlString(@"/index.php/home/homework/changehomeworkdeadline")//修改提交作业(修改原接口)
#define Assignmenthomework      NewUrlString(@"/index.php/home/homework/addhomework")//布置作业
#define GetHomeworkDetail       NewUrlString(@"/index.php/home/homework/getHomework")//获得作业详情
#define Getknowledgepointslist  NewUrlString(@"/index.php/home/homework/getknowledgepointslist")//获取知识点
#define DeleteHomework          NewUrlString(@"/index.php/home/homework/deletehomework")//删除作业
#define Getfinishhomeworklist   NewUrlString(@"/index.php/home/homework/getfinishhomeworklist")//获取(已/未)做作业学生列表
#define Getstudentanswer        NewUrlString(@"/index.php/home/homework/getstudentanswer")//获取学生作业答案
#define Finishhomework          NewUrlString(@"/index.php/home/homework/finishhomework")//学生提交答案接口
#define Checkhomeworkanswer     NewUrlString(@"/index.php/home/homework/checkhomeworkanswer")//批改作业
#define UploadCorrectPic        NewUrlString(@"/index.php/home/homework/uploadCorrectingPicture")//批改作业
#define applyForGroup           NewUrlString(@"/index.php/home/group/applyForGroup")//学生申请加入学习组
#define studentGroupList        NewUrlString(@"/index.php/home/group/studentGroupList")//学生获取学习组
#define getGroupInfo            NewUrlString(@"/index.php/home/group/getGroupInfo")//获取学习组信息(介绍/科目/名称/老师信息)
#define Gethomeworkcheck        NewUrlString(@"/index.php/home/homework/gethomeworkcheck")//查看学生作业批改

#define AddQuestion             NewUrlString(@"/index.php/home/homework/addquestion")//评价回答 踩/赞
#define AddAnswer               NewUrlString(@"/index.php/home/homework/addanswer")//评价回答 踩/赞

#define GetQuestion             NewUrlString(@"/index.php/home/homework/getQuestion")//问题详情及回复列表
#define GetQuestionList         NewUrlString(@"/index.php/home/homework/questionlist")//问题/互动圈列表
#define Evaluateanswer          NewUrlString(@"/index.php/home/homework/evaluateanswer")//评价回答 踩/赞
#define QuickRemindHomeworkSubmit         NewUrlString(@"/index.php/home/homework/quickRemindHomeworkSubmit")//一键提醒

#define remindHomeworkSubmit    NewUrlString(@"/index.php/home/homework/remindHomeworkSubmit")//个别提醒
#endif
