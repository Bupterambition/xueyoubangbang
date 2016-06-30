//
//  UILoginVerifyViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UILoginVerifyViewController.h"
#import "UILoginRegistClassViewController.h"

#import "UILoginRegistSetPasswordViewController.h"
#import "UILoginRegistInviteCodeViewController.h"
@interface UILoginVerifyViewController ()
{
    UITextField *m_phoneField;
    UITextField *m_verifyField;
    UIButton *m_btnNext;
    NSTimer *countTimer;
    UIButton *btnGetVerify;
    
    NSInteger count;
}
@end

@implementation UILoginVerifyViewController

- (id)init
{
    self = [super init];
    if(self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 60;
    // Do any additional setup after loading the view.
    [self createViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:m_phoneField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:m_verifyField];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [countTimer invalidate];
}

- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"注册帮帮账号";
    //隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapss:)];
    [self.view addGestureRecognizer:tap];
    
//    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(doNext)];
//    rightBar.enabled = NO;
//    self.navigationItem.rightBarButtonItem = rightBar;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];

    static CGFloat fieldH = 50;
    UIView *label1Container = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, kPaddingTop, SCREEN_WIDTH - 2 * kPaddingLeft, fieldH)];
    [self.view addSubview:label1Container];
    label1Container.backgroundColor = [UIColor whiteColor];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, fieldH)];
    [label1Container addSubview:label1];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"手机号";
    m_phoneField = [[UITextField alloc] initWithFrame:CGRectMake([label1 rightX], 0, label1Container.frame.size.width - label1.frame.size.width, fieldH)];
    m_phoneField.placeholder = @"请输入您的手机号";
    m_phoneField.keyboardType = UIKeyboardTypeNumberPad;
    m_phoneField.clearButtonMode = UITextFieldViewModeAlways;
    [label1Container addSubview:m_phoneField];
    
    UIView *label2Container = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, [label1Container bottomY] + 2, SCREEN_WIDTH - 2 * kPaddingLeft, fieldH)];
    [self.view addSubview:label2Container];
    label2Container.backgroundColor = [UIColor whiteColor];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, fieldH)];
    [label2Container addSubview:label2];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"验证码";
    m_verifyField = [[UITextField alloc] initWithFrame:CGRectMake([label2 rightX], 0, 120, fieldH)];
    m_verifyField.keyboardType = UIKeyboardTypeNumberPad;
    m_verifyField.placeholder = @"请输入验证码";
    m_verifyField.keyboardType = UIKeyboardTypeNumberPad;
    m_verifyField.clearButtonMode = UITextFieldViewModeAlways;
    [label2Container addSubview:m_verifyField];
    btnGetVerify = [UIButton buttonWithType:UIButtonTypeCustom];
    [label2Container addSubview:btnGetVerify];
    btnGetVerify.frame = CGRectMake([m_verifyField rightX], 0, label2Container.frame.size.width - [m_verifyField rightX], fieldH);
    [btnGetVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [btnGetVerify setBackgroundColor:UIColorFromRGB(0x5fa4a4)];
    [btnGetVerify addTarget:self action:@selector(doGetVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    btnGetVerify.enabled = NO;
    btnGetVerify.backgroundColor = UIColorFromRGB(0x666666);
    
    UIButton *btnNext = BUTTON_CUSTOM(180);
    [btnNext setTitle:@"下一步" forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(doNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNext];
    btnNext.enabled = NO;
    m_btnNext = btnNext;
    
    UIButton *btnInvite = [UIButton buttonWithType:UIButtonTypeCustom];
    btnInvite.frame = CGRectMake(200, [btnNext bottomY] + 20, 100, 50);
    btnInvite.titleLabel.font = FONT_CUSTOM(13);
    [btnInvite setTitleColor:UIColorFromRGB(0x5fa4a4) forState:UIControlStateNormal];
    [btnInvite setTitle:@"我有邀请码" forState:UIControlStateNormal];
    [btnInvite addTarget:self action:@selector(doInvite) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnInvite];
}

- (void)textFieldChanged:(id)sender
{
    NSString *regex = @"^[0-9]{11}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:m_phoneField.text];
    
    if(!isValid)
    {
        m_btnNext.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        btnGetVerify.enabled = NO;
        btnGetVerify.backgroundColor = UIColorFromRGB(0x666666);
    }
    else
    {
        m_btnNext.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        btnGetVerify.enabled = YES;
        btnGetVerify.backgroundColor = UIColorFromRGB(0x5fa4a4);
    }
}

- (void)doTapss:(UIGestureRecognizer *)tap{
    NSLog(@"隐藏键盘");
    UIView *firstResponse = [self.view findFirstResponder];
    [firstResponse resignFirstResponder];
}

- (void)doGetVerifyCode
{
    
    if(countTimer)
    {
        [countTimer invalidate];
        countTimer = nil;
    }
    [btnGetVerify setTitle:[NSString stringWithFormat:@"(%d)",count] forState:UIControlStateNormal];
    btnGetVerify.enabled = NO;
    btnGetVerify.backgroundColor = UIColorFromRGB(0x666666);
    countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doCount) userInfo:nil repeats:YES];
    
    [AFNetClient GlobalPost:kUrlGetVerifyCode parameters:@{@"phone":m_phoneField.text} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        NSLog(@"kUrlGetVerifyCode : %@",dataDict);
        if(isUrlSuccess(dataDict))
        {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            m_btnNext.enabled = YES;
        }
        else
        {
            [CommonMethod showAlert:urlErrorMessage(dataDict)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)doCount
{
    if(count <= 0)
    {
        [countTimer invalidate];
        countTimer = nil;
        [btnGetVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
        btnGetVerify.enabled = YES;
        btnGetVerify.backgroundColor = UIColorFromRGB(0x5fa4a4);
        count = 60;
    }
    else
    {
        count --;
        [btnGetVerify setTitle:[NSString stringWithFormat:@"(%d)",count] forState:UIControlStateNormal];
    }
}

- (void)doNext
{
//    [self.navigationController pushViewController:[[UILoginRegistSetPasswordViewController alloc] init] animated:YES];
//    return;
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    [AFNetClient GlobalGet:kUrlVerifyCodeCheck parameters:@{@"phone":m_phoneField.text,@"code":m_verifyField.text} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView :mainWindow animated:YES];
//        [GlobalVar instance].registerInfo.phone = @"18855152670";
//        [self.navigationController pushViewController:[[UILoginRegistSetPasswordViewController alloc] init] animated:YES];
//        return ;
        if(isUrlSuccess(dataDict))
        {
            [GlobalVar instance].registerInfo.phone = [dataDict objectForKey:@"phone"];
            [self.navigationController pushViewController:[[UILoginRegistSetPasswordViewController alloc] init] animated:YES];
        }
        else
        {
            [CommonMethod showAlert:urlErrorMessage(dataDict)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        [CommonMethod showAlert:@"未能连接到服务器"];
    }];
    
//    [GlobalVar instance].registerInfo.phone = m_phoneField.text;
//    [self.navigationController pushViewController:[[UILoginRegistSetPasswordViewController alloc] init] animated:YES];
}

- (void)doInvite
{
    [self.navigationController pushViewController:[[UILoginRegistInviteCodeViewController alloc] init] animated: YES];
}

- (void)doBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:m_phoneField];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:m_verifyField];
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
