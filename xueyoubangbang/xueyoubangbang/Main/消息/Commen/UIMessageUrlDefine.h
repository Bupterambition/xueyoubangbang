//
//  UIMessageUrlDefine.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#ifndef xueyoubangbang_UIMessageUrlDefine_h
#define xueyoubangbang_UIMessageUrlDefine_h
#define kUrlHead                @"http://cgi.sharingpop.cn/"
#define kUrlTest                @"http://10.210.110.72"
#define NewUrlString(url)       [NSString stringWithFormat:@"%@%@",kUrlHead,url]

#define GetMessageList          NewUrlString(@"/index.php/home/system/getRemindInfo")//获取消息列表
#define DeleteMessage           NewUrlString(@"/index.php/home/system/deleteRemindInfo")//.删除消息列表
#define GetFriendAddList        NewUrlString(@"/index.php/home/system/friendAddList")
#define AcceptFriendAdd         NewUrlString(@"/index.php/home/system/friendAdd")
#endif
