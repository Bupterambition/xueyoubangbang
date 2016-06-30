//
//  Url.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/24.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#ifndef xueyoubangbang_Url_h
#define xueyoubangbang_Url_h


#endif

#define kAppStoreId             @"993552721"   //提交审核前，改为自己的appid
#define kUrlAppDownload         [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@",kAppStoreId]

//测试服务器
//#define kUrlHead                @"http://203.156.220.90:8080/homework/"
//生成服务器
#define kUrlHead                @"http://cgi.sharingpop.cn"
#define NewkUrlHead             @"http://10.210.110.72/"

#define kUrlResHead             [NSString stringWithFormat:@"%@%@",kUrlHead,@"/Public/"]
#define kUrlNewResHead             [NSString stringWithFormat:@"%@%@",kUrlHead,@"/Public/"]

#define UrlResString(url)       [NSString stringWithFormat:@"%@%@",kUrlResHead,url]
#define UrlResStringForImg(url) [NSString stringWithFormat:@"%@%@",kUrlNewResHead,url]
#define UrlString(url)          [NSString stringWithFormat:@"%@%@",kUrlHead,url]

#define kUrlGetVerifyCode       UrlString(@"/index.php/home/index/getVerifyCode")
#define kUrlVerifyCodeCheck     UrlString(@"/index.php/home/index/verifyCodeCheck")
#define kUrlRegister            UrlString(@"/index.php/home/index/register")
#define kUrlLogin               UrlString(@"/index.php/home/index/login")
#define kUrlGetUserInfo         UrlString(@"/index.php/home/index/getUserInfo")
#define kUrlGetSchoolList       UrlString(@"/index.php/home/index/getSchoolList")
#define kUrlGetClassMates       UrlString(@"/index.php/home/index/getClassmates")
#define kUrlGetUserClass        UrlString(@"/index.php/home/index/getUserClass")
//这里是卢家辉加上去的
#define kUrlGetAllUserClass     UrlString(@"/index.php/home/index/getAllUserClass")
///
#define kUrlSetClassInfo        UrlString(@"/index.php/home/index/setClassInfo")
#define kUrlGetHomeInfo         UrlString(@"/index.php/home/home/getHomeInfo")
#define kUrlHomeworkList        UrlString(@"/index.php/home/homework/homeworklist")
#define kUrlGetHomework         UrlString(@"/index.php/home/homework/getHomework")
#define kUrlQuestionList        UrlString(@"/index.php/home/homework/questionlist")
#define kUrlGetQuestion         UrlString(@"/index.php/home/homework/getQuestion")
#define kUrlFinishHomework      UrlString(@"/index.php/home/homework/finishhomework")
#define kUrlAddHomework         UrlString(@"/index.php/home/homework/addhomework")
#define kUrlAddQuestion         UrlString(@"/index.php/home/homework/addquestion")
#define kUrlDeleteHomework      UrlString(@"/index.php/home/homework/deletehomework")
#define kUrlAddAnswer           UrlString(@"/index.php/home/homework/addanswer")
#define kUrlSetName             UrlString(@"/index.php/home/index/setname")
#define kUrlModifyPhone         UrlString(@"/index.php/home/index/modifyPhone")
#define kUrlSetQQ               UrlString(@"/index.php/home/index/setqq")
#define kUrlGetUserList         UrlString(@"/index.php/home/index/getUserClass")
#define kUrlGetTastList         UrlString(@"/index.php/home/system/getTaskList")
#define kUrlGetSubjectList      UrlString(@"/index.php/home/index/getSubjectList")
#define kUrlThirdRegister       UrlString(@"/index.php/home/index/thirdRegister")
#define kUrlThirdLogin          UrlString(@"/index.php/home/index/thirdLogin")
#define kUrlUploadHeader        UrlString(@"/index.php/home/index/uploadHeader")

#define kUrlSetRemindInfo       UrlString(@"/index.php/home/system/setRemindinfo")
#define kUrlQuitClass           UrlString(@"/index.php/home/system/quitClass")

#define kUrlVersion             UrlString(@"/index.php/home/index/version")
#define kUrlFeedback            UrlString(@"/index.php/home/system/feedback")

#define kUrlContactList         UrlString(@"/index.php/home/system/contact_list")
#define kUrlAddFriendReq        UrlString(@"/index.php/home/system/addFriendReq")
#define kUrlJudgeFriend         UrlString(@"/index.php/home/system/isFriend")
#define kUrlFriendAdd           UrlString(@"/index.php/home/system/friendAdd")
#define kUrlFriendAddList       UrlString(@"/index.php/home/system/friendAddList")

#define kUrlGetStudents         UrlString(@"/index.php/home/index/getstudents")

#define kUrlGetSystemSwitch     UrlString(@"/index.php/home/system/getSystemSwitch")
#define kUrlSetSystemSwitch     UrlString(@"/index.php/home/system/setSystemSwitch")
#define kUrlGetRemindTimeList   UrlString(@"/index.php/home/system/getRemindTimeList")
#define kUrlSetRemindTime       UrlString(@"/index.php/home/system/setRemindTime")
#define kUrlUpdateRemindTime    UrlString(@"/index.php/home/system/updateRemindTime")
#define kUrlDelRemindTime       UrlString(@"/index.php/home/system/delRemindTime")

#define kUrlSetDeviceToken      UrlString(@"/index.php/home/system/setDeviceToken")
#define kUrlForgetPwd           UrlString(@"/index.php/home/index/forgetPwd")


#define kUrlgetPrivateClass        UrlString(@"/index.php/home/index/getPrivateClass")
#define kUrlgetPrivateSchool       UrlString(@"/index.php/home/index/getPrivateSchool")
#define kUrlgetGradeList           UrlString(@"/index.php/home/index/getGradeList")
#define kUrlgetGradeClass          UrlString(@"/index.php/home/index/getGradeClass")
