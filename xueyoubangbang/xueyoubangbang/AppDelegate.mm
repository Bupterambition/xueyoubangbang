//
//  AppDelegate.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/11.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import "MainTabViewController.h"
#import "UILoginViewController.h"
#import "UIRoleSelectViewController.h"
#import "UIWelcomViewController.h"
#import "CrabCrashReport.h"
#import "CustomURLCache.h"
//#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
//#import <TencentOpenAPI/QQApi.h>
#define BAIDUMAPKEY @"R6vdM1mDh2lOLkNSx7yd62fb"
#define kStoreAppId @"993552721"  // （appid数字串）
@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate,WBHttpRequestDelegate,UIAlertViewDelegate,CrashSignalCallBackDelegate>{
    BMKMapManager* _mapManager;
}

@end

@implementation AppDelegate

/**
 *  检查新版本更新
 */
-(void)checkAppUpdate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        
        NSURLRequest *curRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",kStoreAppId]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40];
        NSData *receiveData = [NSURLConnection sendSynchronousRequest:curRequest returningResponse:nil error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (receiveData != nil) {
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
                NSArray *infoArray = [dict objectForKey:@"results"];
                if ([infoArray count]) {
                    NSDictionary *resultInfo = [NSDictionary dictionaryWithDictionary:infoArray[0]];
                    NSString *curNewVersion = [[NSString stringWithFormat:@"%@",resultInfo[@"version"]]stringByReplacingOccurrencesOfString:@"." withString:@""];
                    NSString *deviceVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
                    
                    if ([curNewVersion isEqualToString:deviceVersion] || [curNewVersion intValue] < [deviceVersion intValue]) {
                        
                    }else{
                        [MBProgressHUD hideAllHUDsForView:nil animated:NO];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新的版本" message:[resultInfo valueForKey:@"releaseNotes"] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                        alert.tag = 10000;
                        [alert show];
                    }
                }
            }
        });
    });
#if !OS_OBJECT_USE_OBJC
    dispatch_release(requestQueue);
#endif
}
/**
 *  使用缓存
 */
- (void)enableCache{
    CustomURLCache *URLCache = [CustomURLCache standardURLCache];
    [NSURLCache setSharedURLCache:URLCache];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", kStoreAppId]];
        [[UIApplication sharedApplication] openURL:url];
    }
}
- (void)crashCallBack{
    [[CrabCrashReport sharedInstance] addCrashAttachLog:@"xueyoubangbang" forKey:@"developer"];
    [[CrabCrashReport sharedInstance] addCrashAttachLog:@"xueyoubangbang" forKey:@"leader"];
}
//1.当程序处于关闭状态收到推送消息时，点击图标会调用- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions　这个方法，那么消息给通过launchOptions这个参数获取到。
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[CrabCrashReport sharedInstance] setBuildnumber:@"2.1.0"];
    [[CrabCrashReport sharedInstance] setCrashCallBackDelegate:self];
    //Crab SDK初始化代码
    [[CrabCrashReport sharedInstance] initCrashReporterWithAppKey:@"a35f7809fea2dca4" AndVersion:@"2.1.0" AndChannel:@"AppStore"];
    //第一种情况
    if(launchOptions) {
        NSDictionary* pushNotificationKey =[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            //这里定义自己的处理方式
        }
    }
    [self enableCache];
    [self checkAppUpdate];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *localVersionname = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *plistVersion = [USER_DEFAULT objectForKey:@"productVersion"];
    if([localVersionname isEqualToString:plistVersion])
    {
        if([GlobalVar instance].user == nil)
        {
            UICustomNavigationViewController *nva = [[UICustomNavigationViewController alloc] initWithRootViewController:[[UILoginViewController alloc] init]];
            self.window.rootViewController = nva;
        }
        else
        {
            MainTabViewController *mainTab = [[MainTabViewController alloc]init];
            [self.window setRootViewController:mainTab];
            
        }
    }
    else
    {
        [USER_DEFAULT setObject:localVersionname forKey:@"productVersion"];
        UIWelcomViewController *ctrl = [[UIWelcomViewController alloc] init];
        ctrl.isStart = YES;
        self.window.rootViewController = ctrl;
    }
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.window makeKeyAndVisible];
    
    [GlobalVar tencentOAuth];//QQ注册
    [WXApi registerApp:WeixinAppId];//微信接口注册
    [WeiboSDK enableDebugMode:YES];//打开微博调试
    [WeiboSDK registerApp:WeiboAppKey];//微博接口注册
    
    
    NSLog(@"udid = %@",[OpenUDID value]);
    
    // Register for push notifications
    
    if(IOS_VERSION >= 8.0)
    {
        [application registerForRemoteNotifications];
        
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";//按钮的标示
        action.title=@"Accept";//按钮的标题
        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        //    action.authenticationRequired = YES;
        //    action.destructive = YES;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"action2";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action.destructive = YES;
        
        //2.创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示,推送通知的时候也是根据这个来区分
        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
        
        //3.创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
        [application registerUserNotificationSettings:notiSettings];
    }
    else
    {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeSound];
    }
    [self startBaiduMapSDK];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken {
    
//    NSLog(@"regisger success:%@", pToken);
    //注册成功，将deviceToken保存到应用服务器数据库中，因为在写向ios推送信息的服务器端程序时要用到这个
    
    NSString *tokenStr = [[[pToken.description stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
    
//    [USER_DEFAULT setObject:tokenStr forKey:@"apns_device_token" ];
    [GlobalVar instance].deviceToken = tokenStr;
    NSLog(@"deviceToken str = %@",tokenStr);
//    [CommonMethod showAlert: [NSString stringWithFormat: @"devictToken = %@",tokenStr]];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings NS_AVAILABLE_IOS(8_0)
{
    
}


//2.当程序处于前台工作时，这时候若收到消息推送，会调用- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo这个方法
//3.当程序处于后台运行时，这时候若收到消息推送，如果点击消息或者点击消息图标时，也会调用- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo这个方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    // 处理推送消息
    
    if(application.applicationState == UIApplicationStateActive) {
        //第二种情况
//        if ([[userInfo objectForKey:@'aps'] objectForKey:@'alert']!=NULL) {
//            [WLHelper showAlert:@'推送消息' msg:[[userInfo objectForKey:@'aps'] objectForKey:@'alert']];
//        }
        
    } else {
        //第三种情况
        //这里定义自己的处理方式
    }
    
//    [CommonMethod showAlert:[NSString stringWithFormat: @"message = %@",message]];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Regist fail%@",error); 
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//openURL:
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSLog(@"openURL = %@",url);
//    NSString *urlString = [url absoluteString];
    if([url.scheme isEqualToString: [NSString stringWithFormat:@"tencent%@",QQAppId]]){
        return [TencentOAuth HandleOpenURL:url];
    }
    else if([url.scheme isEqualToString:WeixinAppId]){
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if([url.scheme isEqualToString:[NSString stringWithFormat:@"wb%@",WeiboAppKey]])
    {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return YES;
}

//handleOpenURL:
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSLog(@"handleOpenURL = %@",url);
    if([url.scheme isEqualToString: [NSString stringWithFormat:@"tencent%@",QQAppId]]){
        return [TencentOAuth HandleOpenURL:url];
    }
    else if([url.scheme isEqualToString:WeixinAppId]){
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if([url.scheme isEqualToString:[NSString stringWithFormat:@"wb%@",WeiboAppKey]])
    {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return YES;
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *message = [NSString stringWithFormat:@"响应状态: %ld\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",
                             (long)response.statusCode, [(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        NSLog(@"微博登陆:%@",message);

        if(response.statusCode == WeiboSDKResponseStatusCodeSuccess)
        {
            [GlobalVar instance].weiboToken =  [(WBAuthorizeResponse *)response accessToken];
            [GlobalVar instance].weiboOpenId = [(WBAuthorizeResponse *)response userID];
            [CommonMethod doThirdLoginSuccess:^(MUser *user) {
                
//                [[self.view findFirstResponder] resignFirstResponder];
                [USER_DEFAULT setInteger:(NSInteger) LoginType_Weibo forKey:UserDefaultsKey_LoginType];
                [GlobalVar instance].user = user;
                
                //    [self dismissViewControllerAnimated:NO completion:nil];
                [UIApplication sharedApplication].keyWindow.rootViewController = [[MainTabViewController alloc] init];
            } fail:^(NSString *failMsg) {
                
                //跳到注册页
                if([failMsg isEqualToString:@"未绑定"])
                {
                    [GlobalVar instance].registerInfo.thirdid = [GlobalVar instance].weiboOpenId;
//                    UIViewController *ctrl = [self getCurrentVC];
                    [GlobalVar instance].registerInfo.logType = LoginType_Weibo;
                    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
                    NSString * userInfoUrl = @"https://api.weibo.com/2/users/show.json";
                    [WBHttpRequest requestWithURL:userInfoUrl httpMethod:@"GET" params:@{@"access_token":[GlobalVar instance].weiboToken,@"uid":[GlobalVar instance].weiboOpenId} delegate:self withTag:@""];
                    
                }
                else
                {
                    [CommonMethod showAlert:failMsg];
                }
            } thirdOpenId:[GlobalVar instance].weiboOpenId thirdType:LoginType_Weibo];
        }
    }

}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
    
    
    NSData *resData = [[NSData alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"weibo dict:%@",dict);
    NSString * nameStr = [dict objectForKey:@"name"];
    NSString * imageUrlStr = [dict objectForKey:@"profile_image_url"];
    NSLog(@"name:%@,urlStr:%@",nameStr,imageUrlStr);
    
    [GlobalVar instance].registerInfo.username = nameStr;
    
    if([self.currentViewController isKindOfClass:[UIViewController class]])
    {
        [self.currentViewController presentViewController:[[ UICustomNavigationViewController alloc] initWithRootViewController:[[UIRoleSelectViewController alloc] init] ] animated:YES completion:nil];
    }
}




/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req
{
}




/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp * authResp = (SendAuthResp *)resp;
        [self getAccess_token:authResp.code];
    };
}

-(void)getAccess_token:(NSString *)code
{
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeixinAppId,WeixinSecret,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                
                [GlobalVar instance].weixinToken = [dic objectForKey:@"access_token"];
                [GlobalVar instance].weixinOpenId = [dic objectForKey:@"openid"];
                if([CommonMethod isBlankString:[GlobalVar instance].weixinToken] || [CommonMethod isBlankString:[GlobalVar instance].weixinOpenId])
                {
                    [CommonMethod showAlert:@"登录失败"];
                    return ;
                }
                [CommonMethod doThirdLoginSuccess:^(MUser *user) {
                    //                [[self.view findFirstResponder] resignFirstResponder];
                    [USER_DEFAULT setInteger:(NSInteger) LoginType_Weixin forKey:UserDefaultsKey_LoginType];
                    [GlobalVar instance].user = user;
                    
                    //    [self dismissViewControllerAnimated:NO completion:nil];
                    [UIApplication sharedApplication].keyWindow.rootViewController = [[MainTabViewController alloc] init];
                } fail:^(NSString *failMsg) {
                    //跳到注册页
                    if([failMsg isEqualToString:@"未绑定"])
                    {
                        [GlobalVar instance].registerInfo.thirdid = [GlobalVar instance].weixinOpenId;
                        
                        [self getUserInfo];
                        
                    }
                    else
                    {
                        [CommonMethod showAlert:failMsg];
                    }
                    
                } thirdOpenId:[GlobalVar instance].weixinOpenId thirdType:LoginType_Weixin];
                
            }
        });
    });
}

-(void)getUserInfo
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    [GlobalVar instance].registerInfo.logType = LoginType_Weixin;
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",[GlobalVar instance].weixinToken,[GlobalVar instance].weixinOpenId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                
                [GlobalVar instance].registerInfo.username = [dic objectForKey:@"nickname"];
//                self.wxHeadImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]];
                
                if([self.currentViewController isKindOfClass:[UIViewController class]])
                {
                    [self.currentViewController presentViewController:[[ UICustomNavigationViewController alloc] initWithRootViewController:[[UIRoleSelectViewController alloc] init] ] animated:YES completion:nil];
                }
                
                
                
            }
            else
            {
                [CommonMethod showAlert:@"获取用户信息失败"];
            }
        });
        
    });
}

/**
 *  获取当前正在显示的viewController
 *
 */
// 获取当前处于activity状态的view controller
- (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    if([activityViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tab = (UITabBarController*)activityViewController;
        activityViewController = tab.selectedViewController;
    }
    
    if([activityViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *)activityViewController;
        activityViewController = [nav.viewControllers objectAtIndex:nav.viewControllers.count - 1];
    }
    
    return activityViewController;
}

- (void)startBaiduMapSDK{
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BAIDUMAPKEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}
- (void)application:(UIApplication*)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler{
    
}
@end
