//
//  WeixinActivity.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"
@interface WeixinActivity : UIActivity
{
//    NSString    *m_title;
//    NSString    *m_content;
//    NSURL       *m_url;
//    UIImage *m_thumb;
}

/** 发送的目标场景，可以选择发送到会话(WXSceneSession)或者朋友圈(WXSceneTimeline)。 默认发送到会话。
 * @see WXScene
 */
@property (nonatomic, assign) int scene;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,retain) UIImage *thumb;

@end
