//
//  TencentActivity.m
//  EnglishWeekly
//
//  Created by richardhxy on 14-5-9.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "TencentActivity.h"

@implementation TencentActivity

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

    
    if ([QQApiInterface isQQInstalled]) {
    QQApiURLObject *obj = [QQApiURLObject objectWithURL:[NSURL URLWithString:_url ] title:_title description:_text previewImageData:[_thumb toData] targetContentType:QQApiURLTargetTypeNews];
//    QQApiTextObject *obj = [QQApiTextObject objectWithText:m_title];
//    m_qqApiObject = obj;
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    NSLog(@"sent %d",sent);
    [self handleSendResult:sent];
    [self activityDidFinish:YES];
    }else{
    
    UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装QQ" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [msgbox show];
    }
}


- (NSString *)activityTitle
{
    return @"QQ";
}

-(UIImage *)activityImage
{
    return [UIImage imageNamed:@"share_qq"];
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
