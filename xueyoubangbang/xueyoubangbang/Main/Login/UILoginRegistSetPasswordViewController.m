//
//  UILoginRegistSetPasswordViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/23.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UILoginRegistSetPasswordViewController.h"
#import "UILoginRegistDoneViewController.h"
#import "UILoginRegistClassViewController.h"
@interface UILoginRegistSetPasswordViewController ()
{
    UITextField *m_phoneField;
    UITextField *m_verifyField;
    UIButton *btnNext;
}
@end

@implementation UILoginRegistSetPasswordViewController

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
    [self createViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:m_phoneField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:m_verifyField];
}

- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"设置密码";
    //隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapss:)];
    [self.view addGestureRecognizer:tap];
    
//    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(doNext)];
//    self.navigationItem.rightBarButtonItem = rightBar;
//    rightBar.enabled = NO;
    
    static CGFloat fieldH = 50;
    UIView *label1Container = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, kPaddingTop, SCREEN_WIDTH - 2 * kPaddingLeft, fieldH)];
    [self.view addSubview:label1Container];
    label1Container.backgroundColor = [UIColor whiteColor];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, fieldH)];
    [label1Container addSubview:label1];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"密码";
    m_phoneField = [[UITextField alloc] initWithFrame:CGRectMake([label1 rightX], 0, label1Container.frame.size.width - label1.frame.size.width, fieldH)];
    m_phoneField.secureTextEntry = YES;
    m_phoneField.placeholder = @"请输入密码";
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
    m_verifyField.placeholder = @"再次确认密码";
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
    
    
    btnNext = BUTTON_CUSTOM(180);
    [btnNext setTitle:@"下一步" forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(doNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNext];
    btnNext.enabled = NO;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == m_phoneField)
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
    if([CommonMethod isBlankString:m_phoneField.text] || [CommonMethod isBlankString:m_verifyField.text])
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
    if([CommonMethod isBlankString:m_phoneField.text] || [CommonMethod isBlankString:m_verifyField.text])
    {
        [CommonMethod showAlert:@"请输入密码"];
        return;
    }
    
    if(![m_phoneField.text isEqualToString:m_verifyField.text])
    {
        [CommonMethod showAlert:@"两次输入不一致"];
        return;
    }
    
    
    [GlobalVar instance].registerInfo.pwd = m_phoneField.text;
    MRegister *reg = [GlobalVar instance].registerInfo;
    
    if(reg.thirdid != nil)
    {
        //第三方注册
        
        NSMutableDictionary *para = [[NSMutableDictionary alloc] initWithDictionary :@{@"thirdid":reg.thirdid,@"username":reg.phone, @"pwd":reg.pwd,@"phone":reg.phone,@"roles":reg.roles}];

        if(![CommonMethod isBlankString:reg.invitecode])
        {
            [para setObject:reg.invitecode forKey:@"invitecode"];
        }
        
        
        NSLog(@"kUrlRegister para = %@",para);
        [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];

        [AFNetClient GlobalPost:kUrlThirdRegister parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
            [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
            NSLog(@"%@ = %@",kUrlRegister,dataDict);
            
            if(isUrlSuccess(dataDict))
            {
                [CommonMethod doQQLoginSucess:^(MUser *user) {
                    [GlobalVar instance].registerInfo = nil;
                    if([reg.roles isEqualToString:@"1"])
                    {
                        [self.navigationController pushViewController:[[UILoginRegistDoneViewController alloc] init] animated:YES];
                    }
                    else if([reg.roles isEqualToString:@"2"])
                    {
                        [self.navigationController pushViewController:[[UILoginRegistClassViewController alloc] init] animated:YES];
                    }
                    //                    [CommonMethod showAlert:@"注册成功"];
                } fail:^(NSString *failMsg){
                    [CommonMethod showAlert:failMsg];
                }];
            }
            else
            {
                [CommonMethod showAlert:urlErrorMessage(dataDict)];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
            [CommonMethod showAlert:@"服务异常"];
        }];

    }
    else
    {
        NSMutableDictionary *para = [[NSMutableDictionary alloc] initWithDictionary :@{@"username":reg.phone,@"pwd":reg.pwd,@"phone":reg.phone,@"roles":reg.roles}];

        if(![CommonMethod isBlankString:reg.invitecode])
        {
            [para setObject:reg.invitecode forKey:@"invitecode"];
        }
//        MUser *user = [[MUser alloc] init];
//        user.userid = @"10000013";
//        user.username = @"10000013";
//        user.roles = @"1";
//        user.key = @"33398368263";
//        [GlobalVar instance].user = user;
//        [GlobalVar instance].registerInfo = nil;
//        [self.navigationController pushViewController:[[UILoginRegistDoneViewController alloc] init] animated:YES];
//        return;
        NSLog(@"%@ para = %@",kUrlRegister,para);
//        [self.navigationController pushViewController:[[UILoginRegistDoneViewController alloc] init] animated:YES];
        [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];

        [AFNetClient GlobalPost:kUrlRegister parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
            [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
            NSLog(@"%@ = %@",kUrlRegister,dataDict);
//            [self.navigationController pushViewController:[[UILoginRegistDoneViewController alloc] init] animated:YES];
//            return ;
            if(isUrlSuccess(dataDict))
            {
                MUser *user = [MUser objectWithDictionary:[dataDict objectForKey:@"user"]];
                [CommonMethod doBangbangLoginUsername:user.username pwd:[GlobalVar instance].registerInfo.pwd sucess:^(MUser *user) {
                    [GlobalVar instance].registerInfo = nil;
                    [self.navigationController pushViewController:[[UILoginRegistDoneViewController alloc] init] animated:YES];
                    //                    [CommonMethod showAlert:@"注册成功"];
                } fail:^(NSString *failMsg){
                    [CommonMethod showAlert:failMsg];
                }];
            }
            else
            {
                [CommonMethod showAlert:urlErrorMessage(dataDict)];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
            [CommonMethod showAlert:@"服务异常"];
        }];
        

    }
    
    
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
