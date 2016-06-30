//
//  WeixinActivity.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "WeixinActivity.h"

@implementation WeixinActivity

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}

- (NSString *)activityType
{
    return NSStringFromClass([self class]);
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[UIImage class]]) {
            return YES;
        }
        if ([activityItem isKindOfClass:[NSURL class]]) {
            return YES;
        }
        if ([activityItem isKindOfClass:[NSString class]]) {
            return YES;
        }
    }
    return NO;
}
//- (void)prepareWithActivityItems:(NSArray *)activityItems
//{
//    for (id activityItem in activityItems) {
//        if ([activityItem isKindOfClass:[UIImage class]]) {
//            m_thumb = activityItem;
//        }
//        if ([activityItem isKindOfClass:[NSURL class]]) {
//            m_url = activityItem;
//        }
//        if ([activityItem isKindOfClass:[NSString class]]) {
//            m_title = activityItem;
//        }
//    }
//}

- (void)performActivity
{
    if ([WXApi isWXAppInstalled]) {
    SendMessageToWXReq *sendMsg = [[SendMessageToWXReq alloc] init];
    if(_thumb == nil){
        sendMsg.text =  _text;

        sendMsg.bText = YES;
    }
    else
    {
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = _url;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.thumbData = [_thumb toData];
        message.description = _text;
        message.title = _title;
        message.mediaObject = webObj; //不加该属性分享失败
        sendMsg.bText = NO;
        sendMsg.message = message;
        
    }
    sendMsg.scene = self.scene;
    [WXApi sendReq:sendMsg];
//    NSLog(@"sent %d",sent);
//    [self handleSendResult:sent];
    [self activityDidFinish:YES];
    }
    else{
    
    UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [msgbox show];
    }
}

- (NSString *)activityTitle
{
    if(self.scene == 0)
        return @"微信好友";
    return @"朋友圈";
}

-(UIImage *)activityImage
{
    if(self.scene == 0)
        return [UIImage imageNamed:@"share_wechat"];
    return [UIImage imageNamed:@"share_moments"];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"App未注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装手机QQ" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"空间分享不支持纯文本分享，请使用图文分享" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"空间分享不支持纯图片分享，请使用图文分享" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}


@end
