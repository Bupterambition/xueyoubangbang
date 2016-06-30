//
//  UIModifyPassword.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/12.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIModifyPassword.h"

@interface UIModifyPassword()<UITextFieldDelegate>
{
    UITextField *m_oldPassword;
    UITextField *m_phoneField;
    UITextField *m_verifyField;
    UIButton *btnNext;
}

@end

@implementation UIModifyPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:m_phoneField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:m_verifyField];
}

- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"修改密码";
    //隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapss:)];
    [self.view addGestureRecognizer:tap];
    
    //    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(doNext)];
    //    self.navigationItem.rightBarButtonItem = rightBar;
    //    rightBar.enabled = NO;
    
    static CGFloat fieldH = 50;
    
    UIView *label0Container = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, kPaddingTop, SCREEN_WIDTH - 2 * kPaddingLeft, fieldH)];
    [self.view addSubview:label0Container];
    label0Container.backgroundColor = [UIColor whiteColor];
    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, fieldH)];
    [label0Container addSubview:label0];
    label0.textAlignment = NSTextAlignmentCenter;
    label0.text = @"原密码";
    m_oldPassword = [[UITextField alloc] initWithFrame:CGRectMake([label0 rightX], 0, label0Container.frame.size.width - label0.frame.size.width, fieldH)];
    m_oldPassword.secureTextEntry = YES;
    m_oldPassword.placeholder = @"请输入原密码";
    m_oldPassword.returnKeyType = UIReturnKeyNext;
    m_oldPassword.clearButtonMode = UITextFieldViewModeAlways;
    m_oldPassword.delegate = self;
    [label0Container addSubview:m_oldPassword];
    
    UIView *label1Container = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, [label0Container bottomY] + 2, SCREEN_WIDTH - 2 * kPaddingLeft, fieldH)];
    [self.view addSubview:label1Container];
    label1Container.backgroundColor = [UIColor whiteColor];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, fieldH)];
    [label1Container addSubview:label1];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"新密码";
    m_phoneField = [[UITextField alloc] initWithFrame:CGRectMake([label1 rightX], 0, label1Container.frame.size.width - label1.frame.size.width, fieldH)];
    m_phoneField.secureTextEntry = YES;
    m_phoneField.placeholder = @"请输入新密码";
    m_phoneField.returnKeyType = UIReturnKeyNext;
    m_phoneField.clearButtonMode = UITextFieldViewModeAlways;
    m_phoneField.delegate = self;
    [label1Container addSubview:m_phoneField];
    
    UIView *label2Container = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, [label1Container bottomY] + 2, SCREEN_WIDTH - 2 * kPaddingLeft, fieldH)];
    [self.view addSubview:label2Container];
    label2Container.backgroundColor = [UIColor whiteColor];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, fieldH)];
    [label2Container addSubview:label2];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"确认";
    m_verifyField = [[UITextField alloc] initWithFrame:CGRectMake([label2 rightX], 0, label2Container.frame.size.width - label2.frame.size.width, fieldH)];
    m_verifyField.secureTextEntry = YES;
    m_verifyField.placeholder = @"确认新密码";
    m_verifyField.returnKeyType = UIReturnKeyGo;
    m_verifyField.clearButtonMode = UITextFieldViewModeAlways;
    m_verifyField.delegate = self;
    [label2Container addSubview:m_verifyField];
    
    //
    UILabel *labelTip = [[UILabel alloc] init];
    [self.view addSubview:labelTip];
    labelTip.textColor = UIColorFromRGB(0xa0a0a0);
    labelTip.font = FONT_CUSTOM(13);
    labelTip.frame = CGRectMake(0, label2Container.frame.origin.y + label2Container.frame.size.height, SCREEN_WIDTH, 40);
    labelTip.textAlignment = NSTextAlignmentCenter;
    labelTip.text = @"为保护您的账号安全，请勿设置过于简单的密码";
    //
    //    UIImageView *warning = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homework_attention"]];
    //    warning.frame = CGRectMake(kPaddingLeft, label2Container.frame.origin.y + label2Container.frame.size.height, warning.frame.size.width, warning.frame.size.height);
    //    [self.view addSubview:warning];
    
    
    btnNext = BUTTON_CUSTOM([labelTip bottomY] + 20);
    [btnNext setTitle:@"确认" forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(doNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNext];
    btnNext.enabled = NO;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == m_oldPassword)
    {
        [m_phoneField becomeFirstResponder];
    }
    else if(textField == m_phoneField)
    {
        [m_verifyField becomeFirstResponder];
    }
    else if(textField == m_verifyField)
    {
        [self doNext];
    }
    return YES;
}

- (void)textFieldChanged:(id)sender
{
    if([CommonMethod isBlankString:m_phoneField.text] || [CommonMethod isBlankString:m_verifyField.text] || [CommonMethod isBlankString:m_oldPassword.text])
    {
        btnNext.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else
    {
        btnNext.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)doTapss:(UIGestureRecognizer *)tap{
    NSLog(@"隐藏键盘");
    UIView *firstResponse = [self.view findFirstResponder];
    [firstResponse resignFirstResponder];
}

- (void)doNext
{
    if([CommonMethod isBlankString:m_phoneField.text] || [CommonMethod isBlankString:m_verifyField.text] || [CommonMethod isBlankString:m_oldPassword.text])
    {
        [CommonMethod showAlert:@"请输入密码"];
        return;
    }
    
    if(![m_phoneField.text isEqualToString:m_verifyField.text])
    {
        [CommonMethod showAlert:@"两次输入不一致"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid,@"key":[GlobalVar instance].user.key,@"phone":[GlobalVar instance].user.phone,@"oldpass":m_oldPassword.text,@"password":m_phoneField.text};
    [AFNetClient GlobalPost:kUrlForgetPwd parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        if(isUrlSuccess(dataDict))
        {
            [CommonMethod showAlert:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [CommonMethod showAlert:urlErrorMessage(dataDict)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        [CommonMethod showAlert:@"网络异常"];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
