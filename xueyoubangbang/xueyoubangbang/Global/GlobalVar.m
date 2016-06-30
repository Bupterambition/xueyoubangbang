//
//  GlobalVar.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/23.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "GlobalVar.h"
#import "MHomeInfo.h"
@interface GlobalVar()
{
    MUser *_user;
    MHomeinfo *_homeinfo;
    UIImage *_header;
    MRegister *_registerInfo;
    NSString *_weiboOpenId;
    NSString *_weiboToken;
    
    NSString *_weixinOpenId;
    NSString *_weixinToken;
    
    MMessageSetting *_messageSetting;
}

@end

@implementation GlobalVar

-(id)init
{
    self = [super init];
    if(self)
    {
        _roles = 1;
    }
    return self;
}

+ (GlobalVar *)instance
{
    static GlobalVar *sharedGlobalVarInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobalVarInstance = [[GlobalVar alloc] init];
    });
    return sharedGlobalVarInstance;
}

+ (TencentOAuth *)tencentOAuth
{
    static TencentOAuth *sharedTencentOAuthInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedTencentOAuthInstance = [[TencentOAuth alloc] initWithAppId:QQAppId andDelegate:nil];
    });
    return sharedTencentOAuthInstance;
}

- (void)setWeiboOpenId:(NSString *)weiboOpenId
{
    _weiboOpenId = weiboOpenId;
    if(_weiboOpenId != nil)
    {
        [USER_DEFAULT setObject:_weiboOpenId forKey:UserDefaultKey_WeiboOpenId];
    }
    else
    {
        [USER_DEFAULT removeObjectForKey:UserDefaultKey_WeiboOpenId];
    }
}

- (NSString *)weiboOpenId
{
    return [USER_DEFAULT objectForKey:UserDefaultKey_WeiboOpenId];
}

- (void)setWeiboToken:(NSString *)weiboToken
{
    _weiboToken = weiboToken;
    if(_weiboToken != nil)
    {
        [USER_DEFAULT setObject:_weiboToken forKey:UserDefaultKey_WeiboToken];
    }
    else
    {
        [USER_DEFAULT removeObjectForKey:UserDefaultKey_WeiboToken];
    }
}

- (NSString *)weiboToken
{
    return [USER_DEFAULT objectForKey:UserDefaultKey_WeiboToken];
}

- (void)setWeixinOpenId:(NSString *)weixinOpenId
{
    _weixinOpenId = weixinOpenId;
    if(_weixinOpenId != nil)
    {
        [USER_DEFAULT setObject:_weixinOpenId forKey:UserDefaultKey_WeixinOpenId];
    }
    else
    {
        [USER_DEFAULT removeObjectForKey:UserDefaultKey_WeixinOpenId];
    }

}


- (MRegister *)registerInfo
{
    if(_registerInfo ==nil)
    {
        _registerInfo = [[MRegister alloc] init];
    }
    return _registerInfo;
}

- (void)setRegisterInfo:(MRegister *)registerInfo
{
    _registerInfo = registerInfo;
}

-(MUser *)user
{
    if(!_user)
    {
        _user = [MUser objectWithDictionary: [USER_DEFAULT objectForKey:UserDefaultKey_User]];
    }
    return _user;
}
-(void)setUser:(MUser *)user
{
    _user = user;
    if(user != nil)
    {
        [USER_DEFAULT setObject:[JsonToModel dictionaryFromObject:user] forKey:UserDefaultKey_User];
    }
    else
    {
        [USER_DEFAULT removeObjectForKey:UserDefaultKey_User];
    }
}


- (void)setHeader:(UIImage *)header
{
    _header = header;
    if(header != nil)
    {
        NSData *data;
        if (UIImagePNGRepresentation(header) == nil) {
        
            data = UIImageJPEGRepresentation(header, 1);
        } else {
            data = UIImagePNGRepresentation(header);
        }
        [USER_DEFAULT setObject:data forKey:[NSString stringWithFormat:@"%@%@", UserDefaultsKey_Header,self.user.userid]];
    }
    else
    {
        [USER_DEFAULT removeObjectForKey:[NSString stringWithFormat:@"%@%@", UserDefaultsKey_Header,self.user.userid]];
    }
}

- (UIImage *)header
{
    if(!_header)
    {
        _header = [UIImage imageWithData: [USER_DEFAULT objectForKey:[NSString stringWithFormat:@"%@%@", UserDefaultsKey_Header,self.user.userid]]];
    }
    return _header;
}

-(MHomeinfo *)homeInfo
{
    if(!_homeinfo)
    {
        _homeinfo = [[MHomeinfo alloc] init];
    }
    return _homeinfo;
}

- (void)setHomeInfo:(MHomeinfo *)homeInfo
{
    _homeinfo = homeInfo;
}

- (void)setMessageSetting:(MMessageSetting *)messageSetting
{
    _messageSetting = messageSetting;
    if(_messageSetting!=nil)
    {
        [USER_DEFAULT setObject:[messageSetting toDictionary] forKey:@"messageSetting"];
    }
    else
    {
        [USER_DEFAULT removeObjectForKey:@"messageSetting"];
    }
}

- (MMessageSetting *)messageSetting
{
    
    if(!_messageSetting)
    {
        _messageSetting = [MMessageSetting objectiWithDictionary: [USER_DEFAULT objectForKey:@"messageSetting"]];
        if(!_messageSetting)
        {
            MMessageSetting *m = [[MMessageSetting alloc] init];
            m.wholeOn = NO;
            m.homeworkOn = YES;
            m.homeworkTime = [NSMutableArray array];
            _messageSetting = m;
        }
    }
    
    return _messageSetting;
}

- (void)setDeviceToken:(NSString *)deviceToken
{
    if([CommonMethod isBlankString:deviceToken])
    {
        [USER_DEFAULT removeObjectForKey:@"apns_device_token"];
    }
    else
    {
        [USER_DEFAULT setObject:deviceToken forKey:@"apns_device_token"];
    }
    
}

- (NSString *)deviceToken
{
    return [USER_DEFAULT objectForKey:@"apns_device_token"];
}

@end
