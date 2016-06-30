//
//  UIMineModifyUsernameViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/29.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineModifyUsernameViewController.h"

@interface UIMineModifyUsernameViewController ()
{
    UITextField *field;
}
@end

@implementation UIMineModifyUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
}

- (void)createView
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"修改昵称";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(doSave)];
    
    field = [[UITextField alloc] init];
    [self.view addSubview:field];
    field.frame = CGRectMake(kPaddingLeft, kPaddingTop, SCREEN_WIDTH - kPaddingLeft * 2, 45);
    field.backgroundColor = [UIColor whiteColor];
    field.clearButtonMode = UITextFieldViewModeAlways;
    field.text = [GlobalVar instance].user.username;
}

- (void)doSave
{
    
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    NSString *newname = field.text;
    NSDictionary *para = @{@"userId":[GlobalVar instance].user.userid,@"key":[GlobalVar instance].user.key,@"realName":newname};
    [AFNetClient GlobalGet:kUrlSetName parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        
        if(isUrlSuccess(dataDict))
        {
            [GlobalVar instance].user.username = newname;
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
