//
//  UIHomeworkApplyGroupsForsThird.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/15.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkApplyGroupsForsThird.h"
#import "BRPlaceholderTextView.h"
#import "UIHomeworkViewModel.h"
#import "MBProgressHUD+MJ.h"
@interface UIHomeworkApplyGroupsForsThird ()
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *applyTextView;

@end

@implementation UIHomeworkApplyGroupsForsThird

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加小组请求";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(applyGroup)];
    self.applyTextView.placeholder = @"请填写申请加入原因";
    self.applyTextView.maxTextLength = 50;
    [self.applyTextView becomeFirstResponder];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.applyTextView action:@selector(resignFirstResponder)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)applyGroup{
    [self.applyTextView resignFirstResponder];
    [UIHomeworkViewModel applyForGroupWithParams:@{@"groupid":self.groupDic[@"groupid"],@"studentid":[GlobalVar instance].user.userid }withCallBack:^(BOOL success,NSString *content) {
        if (success) {
            [MBProgressHUD showSuccess:@"已发送申请"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            [MBProgressHUD showError:content];
        }
    }];
}


@end
