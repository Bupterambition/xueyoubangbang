//
//  UIPhoneViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/28.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIPhoneViewController.h"
#import "MBProgressHUD+MJ.h"
@interface UIPhoneViewController ()
{
    UITextField *m_phoneField;
    UITextField *m_verifyField;
    UIView *editView;
    UIButton * _btnSure;
}
@end

@implementation UIPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
}

- (void)createView
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"修改绑定手机";
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"binding_phone_icon"]];
    icon.frame = CGRectMake(SCREEN_WIDTH / 2 - icon.frame.size.width / 2, 60, icon.frame.size.width, icon.frame.size.height);
    [self.view addSubview:icon];
    
    UILabel *label1 = [[UILabel alloc]init];
    [self.view addSubview:label1];
    label1.textAlignment  =NSTextAlignmentCenter;
    label1.frame = CGRectMake(0, [icon bottomY] + 20, SCREEN_WIDTH, 20);
    label1.font = FONT_CUSTOM(16);
    label1.text = [NSString stringWithFormat:@"当前号码：%@",[GlobalVar instance].user.phone];
    
    UILabel *label2 = [[UILabel alloc]init];
    [self.view addSubview:label2];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.frame = CGRectMake(0, [label1 bottomY] , SCREEN_WIDTH, 20);
    label2.font = FONT_CUSTOM(14);
    label2.text = @"更换手机后，下次可使用新手机号登录";
    
    UIButton *btn = BUTTON_CUSTOM([label2 bottomY] + 50);
    [self.view addSubview:btn];
    [btn setTitle:@"修改" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doNext) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showEdit
{
    
    if(editView == nil)
    {
        editView = [[UIView alloc] init];
        editView.backgroundColor = [UIColor whiteColor];
        editView.frame = CGRectMake(0, 80 + kNavigateBarHight, SCREEN_WIDTH, 50 * 2 + 70);
        UIView *layer = [CommonMethod showWindowLayer];
        [layer addSubview:editView];
        
        
        static CGFloat fieldH = 50;
        UIView *label1Container = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, kPaddingTop, SCREEN_WIDTH - 2 * kPaddingLeft, fieldH)];
        [editView addSubview:label1Container];
        label1Container.backgroundColor = [UIColor whiteColor];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, fieldH)];
        [label1Container addSubview:label1];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = @"手机号";
        m_phoneField = [[UITextField alloc] initWithFrame:CGRectMake([label1 rightX], 0, label1Container.frame.size.width - label1.frame.size.width, fieldH)];
        m_phoneField.placeholder = @"请输入新的手机号";
        m_phoneField.keyboardType = UIKeyboardTypeNumberPad;
        m_phoneField.clearButtonMode = UITextFieldViewModeAlways;
        [label1Container addSubview:m_phoneField];
        
        UIView *sep1 = [[UIView alloc] init];
        sep1.frame = CGRectMake(kPaddingLeft, [label1Container bottomY] + 1, SCREEN_WIDTH- kPaddingLeft, 1);
        sep1.backgroundColor = VIEW_BACKGROUND_COLOR;
        [editView addSubview:sep1];
        
        UIView *label2Container = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, [label1Container bottomY] + 2, SCREEN_WIDTH - 2 * kPaddingLeft, fieldH)];
        [editView addSubview:label2Container];
        label2Container.backgroundColor = [UIColor whiteColor];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, fieldH)];
        [label2Container addSubview:label2];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.text = @"验证码";
        m_verifyField = [[UITextField alloc] initWithFrame:CGRectMake([label2 rightX], 0, 100, fieldH)];
        m_verifyField.keyboardType = UIKeyboardTypeNumberPad;
        m_verifyField.placeholder = @"请输入验证码";
        m_verifyField.keyboardType = UIKeyboardTypeNumberPad;
        m_verifyField.clearButtonMode = UITextFieldViewModeAlways;
        [label2Container addSubview:m_verifyField];
        
        UIView *sep3 = [[UIView alloc] init];
        sep3.frame = CGRectMake([m_verifyField rightX] + 1, 10, 1, fieldH - 20);
        sep3.backgroundColor = VIEW_BACKGROUND_COLOR;
        [label2Container addSubview:sep3];

        
        UIButton *btnGetVerify = [UIButton buttonWithType:UIButtonTypeCustom];
        [label2Container addSubview:btnGetVerify];
        btnGetVerify.frame = CGRectMake([m_verifyField rightX] + 2, 0, label2Container.frame.size.width - [m_verifyField rightX] - 10, fieldH);
        [btnGetVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btnGetVerify setTitleColor:UIColorFromRGB(0x5fa4a4) forState:UIControlStateNormal];
        [btnGetVerify addTarget:self action:@selector(doGetVerifyCode) forControlEvents:UIControlEventTouchUpInside];
        
       
        
        UIView *sep2 = [[UIView alloc] init];
        sep2.frame = CGRectMake(kPaddingLeft, [label2Container bottomY] + 1, SCREEN_WIDTH- kPaddingLeft, 1);
        sep2.backgroundColor = VIEW_BACKGROUND_COLOR;
        [editView addSubview:sep2];
        
        CGFloat w = ( SCREEN_WIDTH - kPaddingLeft * 4 ) / 2;
         UIButton * _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [editView addSubview:_btnCancel];
        _btnCancel.frame =CGRectMake(kPaddingLeft, [label2Container bottomY] + 10, w, 40);
        _btnCancel.layer.borderColor = STYLE_COLOR.CGColor;
        _btnCancel.layer.borderWidth = 1;
        [_btnCancel setTitleColor:STYLE_COLOR forState:UIControlStateNormal];
        //    footerView.backgroundColor= [UIColor greenColor];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
        
        _btnSure = BUTTON_CUSTOM(0);
        [editView addSubview:_btnSure];
        _btnSure.frame = CGRectMake(kPaddingLeft * 3 + w, _btnCancel.frame.origin.y, w, 40);
//        _btnSure.enabled = NO;
        [_btnSure setTitle:@"确定" forState:UIControlStateNormal];
        [_btnSure addTarget:self action:@selector(doSure) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}

- (void)hideEdit
{
    [editView removeFromSuperview];
    editView = nil;
    [CommonMethod hideWindowLayer];
}

- (void)doCancel
{
    [self hideEdit];
}

- (void)doSure
{
//    [Toast showWithText:@"正在修改"];
    if([CommonMethod isBlankString:m_phoneField.text] || [CommonMethod isBlankString:m_verifyField.text])
    {
        [CommonMethod showAlert:@"信息不完整"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key,@"code":m_verifyField.text,@"phone":m_phoneField.text};
    [self hideEdit];
    [AFNetClient GlobalGet:kUrlModifyPhone parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        if(isUrlSuccess(dataDict))
        {
            MUser *user = [MUser objectWithDictionary:[dataDict objectForKey:@"user"]];
            [GlobalVar instance].user.phone = user.phone;
            [GlobalVar instance].user = [GlobalVar instance].user;
//            [Toast showWithText:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [CommonMethod showAlert:urlErrorMessage(dataDict)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        [CommonMethod showAlert:@"修改失败"];
    }];
}

- (void)doNext
{
    [self showEdit];
    
}

- (void)doGetVerifyCode
{
    NSString *regex = @"^[0-9]{11}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:m_phoneField.text];
    
    if(!isValid)
    {
        [CommonMethod showAlert:@"手机号不正确"];
        return;
    }
    
    [AFNetClient GlobalPost:kUrlGetVerifyCode parameters:@{@"phone":m_phoneField.text} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        NSLog(@"kUrlGetVerifyCode : %@",dataDict);
        if(isUrlSuccess(dataDict))
        {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            _btnSure.enabled = YES;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:nil];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
