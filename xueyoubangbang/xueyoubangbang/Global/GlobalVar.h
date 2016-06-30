//
//  GlobalVar.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/23.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUser.h"
#import "MClass.h"
#import "MRegister.h"
#import "MHomeinfo.h"
#import "MMessageSetting.h"
#import <CoreLocation/CLLocation.h>
#define QQAppId                                         @"1104355872"
#define WeiboAppKey                                     @"411886597"
#define WeiboRedirectURI                                @"http://www.sina.com"
#define WeixinAppId                                     @"wxfdada63d69a5159f"
#define WeixinSecret                                    @"096078f7aa6747bafdc8e4a0b8656279"

//#define QQAppId @"222222"
#define UserDefaultsKey_TencentOAuth_Token              @"TencentOAuth_Token"
#define UserDefaultsKey_TencentOAuth_OpenId             @"TencentOAuth_OpenId"
#define UserDefaultsKey_TencentOAuth_ExpirationDate     @"TencentOAuth_ExpirationDate"
#define UserDefaultsKey_UserId                          @"UserId"
#define UserDefaultsKey_Header                          @"UserHeader"
#define UserDefaultKey_User                             @"User"
#define UserDefaultKey_WeiboOpenId                      @"WeiboOpenId"
#define UserDefaultKey_WeiboToken                       @"WeiboToken"
#define UserDefaultKey_WeixinToken                      @"WeixinToken"
#define UserDefaultKey_WeixinOpenId                     @"WeixinOpenId"

#define UserDefaultsKey_LoginType                       @"LoginType"

@interface GlobalVar : NSObject
@property (nonatomic,strong) MUser *user;
@property (nonatomic,strong) MHomeinfo *homeInfo;
@property (nonatomic,strong) MRegister *registerInfo;
@property (nonatomic,strong) UIImage *header;
@property (nonatomic) NSInteger roles;// 1学生 2老师 3家长
@property (nonatomic) LoginType *logType;
@property (nonatomic,copy) NSString *weiboToken;
@property (nonatomic,copy) NSString *weiboOpenId;
@property (nonatomic,assign) CLLocationCoordinate2D current2DLocation;
@property (nonatomic,copy) NSString *currentAddress;

@property (nonatomic,copy) NSString *weixinToken;
@property (nonatomic,copy) NSString *weixinOpenId;

@property (nonatomic,strong) MMessageSetting *messageSetting;
@property (nonatomic,copy) NSString *deviceToken;
/**
 *  公立学校
 */
@property (nonatomic,strong)MClass *myClass;

+ (GlobalVar *)instance;
+ (TencentOAuth *)tencentOAuth;
//+ (MRegister *)registerInfo;

@end
