//
//  TencentActivity.h
//  EnglishWeekly
//
//  Created by richardhxy on 14-5-9.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface TencentActivity : UIActivity
{
//    QQApiObject *m_qqApiObject;
//    NSString    *m_title;
//    NSURL       *m_url;
//    UIImage     *m_thumb;
}
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,retain)   UIImage *thumb;
@end
