//
//  UIMineModifyQQ.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineModifyQQ.h"

@interface UIMineModifyQQ()
{
    UITextField *field;
}

@end

@implementation UIMineModifyQQ

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
}

- (void)createView
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"修改QQ";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(doSave)];
    
    field = [[UITextField alloc] init];
    [self.view addSubview:field];
    field.frame = CGRectMake(kPaddingLeft, kPaddingTop, SCREEN_WIDTH - kPaddingLeft * 2, 45);
    field.backgroundColor = [UIColor whiteColor];
    field.clearButtonMode = UITextFieldViewModeAlways;
    field.text = [GlobalVar instance].user.qq;
    field.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)doSave
{
    
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    NSString *newname = field.text;
    NSDictionary *para = @{@"userId":[GlobalVar instance].user.userid,@"key":[GlobalVar instance].user.key,@"qq":newname};
    [AFNetClient GlobalGet:kUrlSetQQ parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        
        if(isUrlSuccess(dataDict))
        {
            [GlobalVar instance].user.qq = newname;
            [GlobalVar instance].user = [GlobalVar instance].user;
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


@end
