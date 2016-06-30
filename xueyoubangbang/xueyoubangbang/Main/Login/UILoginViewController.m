//
//  UILoginViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UILoginViewController.h"
#import "TencentActivity.h"
#import "WeixinActivity.h"
#import "UILoginRegistViewController.h"
#import "UILoginVerifyViewController.h"
#import "UIIndexViewController.h"
#import "UIRoleSelectViewController.h"
#import "MainTabViewController.h"
#import "AppDelegate.h"
#import "WeiboSDK.h"
@interface UILoginViewController ()
{
    TencentOAuth *_tencentOAuth;
    NSArray *_permissions ;
    
    UITextField     *m_nameField;
    UITextField     *m_passwordField;
    UIButton        *m_loginBtn;
    NSString* statisticsPageName;
//    LoginUtils *loginUtil;
    
    UIScrollView *myScrollView;
    UITableView *table;
}
@end

@implementation UILoginViewController

#define appId @"1104355872"
#define NAMEFIELDTAG    10000
#define PASSFIELDTAG    10001

- (id)init
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tencentOAuth = [GlobalVar tencentOAuth];
    _tencentOAuth.sessionDelegate = self;
    _permissions =  [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_TOPIC, nil];
    
    [self createViews2];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:m_nameField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:m_passwordField];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([GlobalVar instance].user != nil)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#define TextFieldTag 10001
#define CELL_HEIGHT 50.0f
- (void)createViews2
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"登录帮帮账号";

    //隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [self.view addGestureRecognizer:tap];
    
//    //输入框
//    table = CREATE_TABLE(UITableViewStylePlain);
//    table.frame = CGRectMake(0, 10, table.frame.size.width, table.frame.size.height);
//    table.scrollEnabled = NO;
//    table.allowsSelection = NO;
//    [self.view addSubview:table];
    
    static CGFloat fieldH = 50;
    UIView *label1Container = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, kPaddingTop, SCREEN_WIDTH - 2 * kPaddingLeft, fieldH)];
    [self.view addSubview:label1Container];
    label1Container.backgroundColor = [UIColor whiteColor];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, fieldH)];
    [label1Container addSubview:label1];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"账号";
    m_nameField = [[UITextField alloc] initWithFrame:CGRectMake([label1 rightX], 0, label1Container.frame.size.width - label1.frame.size.width, fieldH)];
    m_nameField.placeholder = @"手机号/帮帮号";
    m_nameField.clearButtonMode = UITextFieldViewModeAlways;
    m_nameField.returnKeyType = UIReturnKeyNext;
    m_nameField.delegate = self;
    [label1Container addSubview:m_nameField];
    
    UIView *label2Container = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, [label1Container bottomY] + 2, SCREEN_WIDTH - 2 * kPaddingLeft, fieldH)];
    [self.view addSubview:label2Container];
    label2Container.backgroundColor = [UIColor whiteColor];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, fieldH)];
    [label2Container addSubview:label2];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"密码";
    m_passwordField = [[UITextField alloc] initWithFrame:CGRectMake([label2 rightX], 0, label2Container.frame.size.width - label2.frame.size.width, fieldH)];
    m_passwordField.clearButtonMode = UITextFieldViewModeAlways;
    m_passwordField.secureTextEntry = YES;
    m_passwordField.placeholder = @"请输入密码";
    m_passwordField.returnKeyType = UIReturnKeyGo;
    m_passwordField.delegate = self;
    [label2Container addSubview:m_passwordField];
    
    //登录按钮
    m_loginBtn = BUTTON_CUSTOM(10 + CELL_HEIGHT * 2 + 11);
    [m_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [m_loginBtn addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    m_loginBtn.enabled = NO;
    [self.view addSubview:m_loginBtn];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setMonth:12];
    [comp setDay:15];
    [comp setYear:2015];
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *myDate1 = [myCal dateFromComponents:comp];
    BOOL boolValue1 = !(NSOrderedDescending == [myDate1 compare:[NSDate date]]);
    if (boolValue1) {
        //其他方式Label
        UILabel *l = [[UILabel alloc] init];
        l.frame = CGRectMake(0, m_loginBtn.frame.origin.y + m_loginBtn.frame.size.height + 50, SCREEN_WIDTH, 25);
        l.textAlignment = NSTextAlignmentCenter;
        l.textColor = UIColorFromRGB(0xadadad);
        l.font = FONT_CUSTOM(13);
        l.text = @"其他方式登录";
        [self.view addSubview:l];
        
        if ([WXApi isWXAppInstalled]) {
            //判断是否有微信
            //微信
            UIButton *btnWeixin = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *imageWeixin = [UIImage imageNamed:@"login_login_thirdpartyweixin"];
            btnWeixin.frame = CGRectMake(SCREEN_WIDTH - imageWeixin.size.width - 45,10 + l.frame.origin.y + l.frame.size.height, imageWeixin.size.width, imageWeixin.size.height);
            if (![QQApi isQQInstalled]) {
                if (![WeiboSDK isWeiboAppInstalled]) {
                    btnWeixin.frame = CGRectMake(SCREEN_WIDTH / 2 - imageWeixin.size.width / 2,10 + l.frame.origin.y + l.frame.size.height, imageWeixin.size.width, imageWeixin.size.height);
                }
            }
            [btnWeixin setBackgroundImage:imageWeixin forState:UIControlStateNormal];
            [btnWeixin addTarget:self action:@selector(doWeixinLogin) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnWeixin];
            
        }
        
        if ([QQApi isQQInstalled]) {
            //判断是否有qq
            //qq
            UIButton *btnQQ = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *imageQQ = [UIImage imageNamed:@"login_login_thirdpartyQQ"];
            btnQQ.frame = CGRectMake(45,10 + l.frame.origin.y + l.frame.size.height, imageQQ.size.width, imageQQ.size.height);
            if (![WXApi isWXAppInstalled]) {
                if (![WeiboSDK isWeiboAppInstalled]) {
                    btnQQ.frame = CGRectMake(SCREEN_WIDTH / 2 - imageQQ.size.width / 2,10 + l.frame.origin.y + l.frame.size.height, imageQQ.size.width, imageQQ.size.height);
                }
            }
            //    [btnQQ setTitle:@"QQ登录" forState:UIControlStateNormal];
            [btnQQ setBackgroundImage:imageQQ forState:UIControlStateNormal];
            [btnQQ addTarget:self action:@selector(doQQLogin) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnQQ];
        }
        
        if ([WeiboSDK isWeiboAppInstalled]) {
            //微博
            UIButton *btnWeibo = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *image = [UIImage imageNamed:@"login_login_thirdpartyweibo"];
            btnWeibo.frame = CGRectMake(SCREEN_WIDTH / 2 - image.size.width / 2,10 + l.frame.origin.y + l.frame.size.height, image.size.width, image.size.height);
            if ([QQApi isQQInstalled]) {
                if (![WXApi isWXAppInstalled]) {
                    btnWeibo.frame = CGRectMake(SCREEN_WIDTH - image.size.width - 45,10 + l.frame.origin.y + l.frame.size.height, image.size.width, image.size.height);
                }
            }
            else{
                if ([WXApi isWXAppInstalled]) {
                    btnWeibo.frame = CGRectMake(45,10 + l.frame.origin.y + l.frame.size.height, image.size.width, image.size.height);
                }
            }
            [btnWeibo setBackgroundImage:image forState:UIControlStateNormal];
            [btnWeibo addTarget:self action:@selector(doWeiboLogin) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnWeibo];
        }
        if (![WeiboSDK isWeiboAppInstalled] && ![QQApi isQQInstalled]&&![WXApi isWXAppInstalled]) {
            [l removeFromSuperview];
        }
    }
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(doRegist)];
    self.navigationItem.rightBarButtonItem = rightBar;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UITextField *field = [[UITextField alloc] init];
        field.frame = CGRectMake(60, 0, 200, CELL_HEIGHT);
        field.tag = TextFieldTag;
        [cell.contentView addSubview:field];
    }
    UITextField *fd = (UITextField *)[ cell viewWithTag:TextFieldTag ];
    if(indexPath.row == 0){
        cell.imageView.image = [UIImage imageNamed:@"ic_user"];
        fd.placeholder = @"手机号/邮箱/用户名";
    }
    else if(indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"ic_password"];
        fd.placeholder = @"密码";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)textFieldChanged:(id)sender
{
    if([CommonMethod isBlankString:m_nameField.text] || [CommonMethod isBlankString:m_passwordField.text])
    {
        m_loginBtn.enabled = NO;
    }
    else
    {
        m_loginBtn.enabled = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == m_nameField) {
        [m_nameField resignFirstResponder];
        [m_passwordField becomeFirstResponder];
    }else if(textField == m_passwordField){
        [ [self.view findFirstResponder] resignFirstResponder ];
        [self doLogin];
    }
    return YES;
}

-(void)doTap:(UIGestureRecognizer *)tap{
    NSLog(@"隐藏键盘");
    UIView *firstResponse = [self.view findFirstResponder];
    [firstResponse resignFirstResponder];
}

- (void)doLogin
{
    if([CommonMethod isBlankString:m_nameField.text] || [CommonMethod isBlankString:m_passwordField.text])
    {
        [CommonMethod showAlert:@"请输入账号或密码"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [CommonMethod doBangbangLoginUsername:m_nameField.text pwd:m_passwordField.text sucess:^(MUser *user) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(user != nil && user.userid != nil)
        {
            [self doLoginSuccess:LoginType_Bangbang user:user];
        }
        else
        {
            [CommonMethod showAlert:@"登录失败"];
        }
    } fail:^(NSString *failMsg){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [CommonMethod showAlert:failMsg];
    }];
}

- (void)doRegist
{
    [self presentViewController:[[ UICustomNavigationViewController alloc] initWithRootViewController:[[UIRoleSelectViewController alloc] init] ] animated:YES completion:nil];
}


- (void)doQQLogin
{
    [_tencentOAuth authorize:_permissions inSafari:NO];
}

- (void)doWeiboLogin
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.currentViewController = self;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WeiboRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"UILoginViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)doWeixinLogin
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.currentViewController = self;
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"com.sdzhu.xueyoubangbang";
    [WXApi sendReq:req];
}

- (void)showActive
{
    
}


- (void)shareButton
{
    NSString *textToShare = @"还在用磁带练听力吗？你已经OUT啦，小伙伴们都开始使用“掌上听说”了，扫描二维码就获取英语周报的最新听力资源，手机练听力更炫酷，赶快行动起来吧!下载地址：http://ew.changyan.com  ";
    //    NSURL *urlToShare = [NSURL URLWithString:@"http://ew.changyan.com"];
    NSArray *activityItems = @[textToShare];
    WeixinActivity *weixinSession =[[WeixinActivity alloc] init];
    weixinSession.scene = 0;
    
    WeixinActivity *weixinTimeLine =[[WeixinActivity alloc] init];
    weixinTimeLine.scene = 1;
    
    NSArray *activities = @[[[TencentActivity alloc]init],weixinSession,weixinTimeLine];
    UIActivityViewController *activityVC =
    [[UIActivityViewController alloc]initWithActivityItems:activityItems
                                     applicationActivities:activities];
    //不出现在活动项目
    if(IOS_VERSION_7_OR_ABOVE){
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                             UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeAirDrop];
    }
    else{
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                             UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeMessage,UIActivityTypeMail];
    }
    [self presentViewController:activityVC animated:TRUE completion:nil];
    UIActivityViewControllerCompletionHandler handler = ^(NSString *activityType, BOOL completed){
        if (nil != activityType) {
            if (completed) {
                
            }
            if ([activityType isEqualToString:UIActivityTypePostToWeibo]) {
                NSLog(@"新浪微博分享！");
            }else if ([activityType isEqualToString:@"com.apple.UIKit.activity.TencentWeibo"]) {
                NSLog(@"腾讯微博分享");
            }else {
                //do nothing
            }
        }
    };
    activityVC.completionHandler = handler;
}

- (void)doShare
{
    //开发者分享的文本内容
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:@"text"];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    NSLog(@"sendCode = %d",sent);
}

- (void)doLoginSuccess:(NSInteger)type user:(MUser *)user
{
    [[self.view findFirstResponder] resignFirstResponder];
    [USER_DEFAULT setInteger:(NSInteger) type forKey:UserDefaultsKey_LoginType];
    [GlobalVar instance].user = user;
    
//    [self dismissViewControllerAnimated:NO completion:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[MainTabViewController alloc] init];

}

- (void)doLoginout
{
    
}

#pragma mark TencentSessionDelegate
//登录成功：
- (void)tencentDidLogin
{
    NSLog(@"登录完成");

    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        NSLog(@"_tencentOAuth.accessToken = %@", _tencentOAuth.accessToken);
        NSLog(@"_tencentOAuth.openId = %@", _tencentOAuth.openId);
        NSLog(@"_tencentOAuth.expirationDate = %@",_tencentOAuth.expirationDate);
        [USER_DEFAULT setObject:_tencentOAuth.accessToken forKey:UserDefaultsKey_TencentOAuth_Token];
        [USER_DEFAULT setObject:_tencentOAuth.expirationDate forKey:UserDefaultsKey_TencentOAuth_ExpirationDate];
        
        [CommonMethod doQQLoginSucess:^(MUser *user) {
            [self doLoginSuccess:LoginType_QQ user:user];
            
        } fail:^(NSString *failMsg){
            
            //跳到注册页
            if([failMsg isEqualToString:@"未绑定"])
            {
                [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
                [_tencentOAuth getUserInfo];
                [GlobalVar instance].registerInfo.thirdid = _tencentOAuth.openId;

            }
            else
            {
                [CommonMethod showAlert:failMsg];
            }
        }];
    }
    else
    {
        NSLog( @"登录不成功 没有获取accesstoken");
    }
}
//非网络错误导致登录失败：
-(void)tencentDidNotLogin:(BOOL)cancelled
{

    if (cancelled)
    {
        NSLog(@"用户取消登录");
    }
    else
    {
        NSLog(@"登录失败");
    }
}
//网络错误导致登录失败：
-(void)tencentDidNotNetWork
{

    NSLog(@"无网络连接，请设置网络");
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
    [GlobalVar instance].registerInfo.logType = LoginType_QQ;
    [GlobalVar instance].registerInfo.username = [response.jsonResponse objectForKey:@"nickname"];
    [self doRegist];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:m_nameField];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:m_passwordField];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
