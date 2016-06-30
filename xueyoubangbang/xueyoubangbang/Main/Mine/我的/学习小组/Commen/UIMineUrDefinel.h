//
//  Url.h
//  xueyoubangbang
//
//  Created by Bob on 15/8/30.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#define kUrlHeada                @"http://cgi.sharingpop.cn/"
#define kUrlTest                @"http://10.210.110.72/"
#define NewUrlString(url)       [NSString stringWithFormat:@"%@%@",kUrlHeada,url]

#define CreatGroupUrl       NewUrlString(@"index.php/home/group/creatGroup")//建立学习小组


#define GetGroupList        NewUrlString(@"index.php/home/group/teacherGroupList")//老师获取学习小组
#define GetGroupMemberList  NewUrlString(@"index.php/home/group/getGroupMemberList")//获取组内成员列表(申请/已加入)
#define GetSignList         NewUrlString(@"index.php/home/group/getSignInList")//获取组内成员列表(申请/已加入)
#define SignInGroup         NewUrlString(@"index.php/home/group/SignInGroup")//签到接口(签到有效/取消签到)
#define DissolveGroup       NewUrlString(@"index.php/home/group/dismissGroup")//解散学习组
#define ChangeGroupName     NewUrlString(@"index.php/home/group/changeGroupName")//修改学习组名称
#define OperateGroupMember  NewUrlString(@"index.php/home/group/operateGroupMember")//操作组人员(接受申请/移除组内学生)
#define SetSignInAddress    NewUrlString(@"index.php/home/group/setSignInAddress")//设置签到位置
#define GetSignInAddress    NewUrlString(@"/index.php/home/group/getSignInAddress")//获取签到位置信息

#define knowledgepointstatistics    NewUrlString(@"/index.php/home/homework/knowledgepointstatistics")//统计知识点
#define GetAccuracystatistics       NewUrlString(@"/index.php/home/homework/accuracystatistics")//统计错误率
#define Getnotelists        NewUrlString(@"/index.php/home/homework/notelist")//获得笔记本列表
#define Deletenote          NewUrlString(@"/index.php/home/homework/deletenote")//删除笔记本
#define Addnote             NewUrlString(@"/index.php/home/homework/addnote")//添加笔记本
#define QuiteGroup          NewUrlString(@"/index.php/home/group/quiteGroup")//退出小组