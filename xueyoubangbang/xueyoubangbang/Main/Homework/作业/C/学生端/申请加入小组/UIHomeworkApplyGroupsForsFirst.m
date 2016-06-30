//
//  UIHomeworkApplyGroupsForsFirst.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/15.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkApplyGroupsForsFirst.h"
#import "MBProgressHUD+MJ.h"
#import <Foundation/Foundation.h>
#import "UIHomeworkViewModel.h"
#import "UIHomeworkApplyGroupsForsSecond.h"
@interface UIHomeworkApplyGroupsForsFirst ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *groupID;

@end

@implementation UIHomeworkApplyGroupsForsFirst

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加小组";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchGroup)];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.groupID becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self searchGroup];
    return YES;
}

- (void)searchGroup{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [MBProgressHUD showMessage:@"搜索中" toView:[UIApplication sharedApplication].keyWindow];
    weak(weakself);
    [UIHomeworkViewModel getGroupInfoWithParams:@{@"groupid":_groupID.text} withCallBack:^(NSDictionary *groupInfo) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (groupInfo) {
            UIHomeworkApplyGroupsForsSecond *vc = [[UIHomeworkApplyGroupsForsSecond alloc] initWithNibName:@"UIHomeworkApplyGroupsForsSecond" bundle:nil];
            vc.groupDic = groupInfo;
            [weakself.navigationController pushViewController:vc animated:YES];
        }
        else{
            [MBProgressHUD showError:@"搜索失败,请检查输入ID"];
        }
    }];
}

@end
