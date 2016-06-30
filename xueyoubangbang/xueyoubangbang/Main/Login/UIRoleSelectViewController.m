//
//  UIRoleSelectViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/30.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIRoleSelectViewController.h"
#import "UILoginVerifyViewController.h"
#import "MainTabViewController.h"
@interface UIRoleSelectViewController()
{
    UILabel *label;
    UIButton *btnParent;
    UIButton *btnStudent;
    UIButton *btnTeacher;
}
@end

@implementation UIRoleSelectViewController

- (id)init
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createView];
}

- (void)createView
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"选择入口";
    
    label = [[UILabel alloc] init];
    [self.view addSubview:label];
    label.frame = CGRectMake(0, 50, SCREEN_WIDTH , 50);
    label.font = FONT_CUSTOM(28);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = STYLE_COLOR;
    label.text = @"请选择入口";
    
    btnParent = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnParent];
    btnParent.frame = CGRectMake(40, [label bottomY] + 40, SCREEN_WIDTH - 80, 50);
    btnParent.layer.borderColor = STYLE_COLOR.CGColor;
    btnParent.layer.borderWidth = 2;
    [btnParent setTitleColor:STYLE_COLOR forState:UIControlStateNormal];
    [btnParent setTitle:@"学生" forState:UIControlStateNormal];
    [btnParent addTarget:self action:@selector(doStudent) forControlEvents:UIControlEventTouchUpInside];
    
    btnStudent = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnStudent];
    btnStudent.frame = CGRectMake(40, [btnParent bottomY] + 40, SCREEN_WIDTH - 80, 50);
    btnStudent.layer.borderColor = STYLE_COLOR.CGColor;
    btnStudent.layer.borderWidth = 2;
    [btnStudent setTitleColor:STYLE_COLOR forState:UIControlStateNormal];
    [btnStudent setTitle:@"老师" forState:UIControlStateNormal];
    [btnStudent addTarget:self action:@selector(doTeacher) forControlEvents:UIControlEventTouchUpInside];
    
//    btnTeacher = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:btnTeacher];
//    btnTeacher.frame = CGRectMake(40, [btnStudent bottomY] + 40, SCREEN_WIDTH - 80, 50);
//    btnTeacher.layer.borderColor = STYLE_COLOR.CGColor;
//    btnTeacher.layer.borderWidth = 2;
//    [btnTeacher setTitleColor:STYLE_COLOR forState:UIControlStateNormal];
//    [btnTeacher setTitle:@"家长" forState:UIControlStateNormal];
//    [btnTeacher addTarget:self action:@selector(doParent) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
}


- (void)doParent
{
    [GlobalVar instance].registerInfo.roles = roleParent;
    [self.navigationController pushViewController:[[UILoginVerifyViewController alloc] init] animated:YES];
}

- (void)doStudent
{
    [GlobalVar instance].registerInfo.roles = roleStudent;
    if([CommonMethod isBlankString: [GlobalVar instance].registerInfo.thirdid])
    {
        [self.navigationController pushViewController:[[UILoginVerifyViewController alloc] init] animated:YES];
    }
    else
    {
        [self doRegisterThird];
    }
}

- (void)doTeacher
{
    [GlobalVar instance].registerInfo.roles = roleTeacher;
    if([CommonMethod isBlankString:[GlobalVar instance].registerInfo.thirdid])
    {
        [self.navigationController pushViewController:[[UILoginVerifyViewController alloc] init] animated:YES];
    }
    else
    {
        [self doRegisterThird];
    }
}

- (void)doBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doRegisterThird
{
    //第三方注册
    MRegister *reg = [GlobalVar instance].registerInfo;
    
    NSMutableDictionary *para = [[NSMutableDictionary alloc] initWithDictionary :@{@"thirdid":reg.thirdid,@"username":reg.username?reg.username:@"",@"roles":reg.roles}];
    
    
    NSLog(@"kUrlRegister para = %@",para);
    [AFNetClient GlobalPost:kUrlThirdRegister parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        NSLog(@"%@ = %@",kUrlRegister,dataDict);
        
        if(isUrlSuccess(dataDict))
        {
            if([GlobalVar instance].registerInfo.logType == LoginType_QQ)
            {
                [CommonMethod doQQLoginSucess:^(MUser *user) {
                    [GlobalVar instance].registerInfo = nil;
                    
                    MainTabViewController *mainTab = [[MainTabViewController alloc]init];
                    [mainWindow setRootViewController:mainTab];
                    
                } fail:^(NSString *failMsg){
                    [CommonMethod showAlert:failMsg];
                }];
            }
            else
            {
                [CommonMethod doThirdLoginSuccess:^(MUser *user) {
                    [GlobalVar instance].registerInfo = nil;
                    
                    MainTabViewController *mainTab = [[MainTabViewController alloc]init];
                    [mainWindow setRootViewController:mainTab];
                } fail:^(NSString *failMsg) {
                    [CommonMethod showAlert:failMsg];
                } thirdOpenId:[GlobalVar instance].registerInfo.thirdid thirdType:[GlobalVar instance].registerInfo.logType];
            }
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

@end
