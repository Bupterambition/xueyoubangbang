//
//  UILoginRegistInviteCodeViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/23.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UILoginRegistInviteCodeViewController.h"

@interface UILoginRegistInviteCodeViewController ()
{
    UITextField *field;
}
@end

@implementation UILoginRegistInviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
}
- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"输入邀请码";
    //隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapss:)];
    [self.view addGestureRecognizer:tap];
    
    static CGFloat fieldH = 50;
    UIView *label1Container = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, kPaddingTop, SCREEN_WIDTH - 2 * kPaddingLeft, fieldH)];
    [self.view addSubview:label1Container];
    label1Container.backgroundColor = [UIColor whiteColor];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, fieldH)];
    [label1Container addSubview:label1];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"邀请码";
    UITextField *m_phoneField = [[UITextField alloc] initWithFrame:CGRectMake([label1 rightX], 0, label1Container.frame.size.width - label1.frame.size.width, fieldH)];
    field = m_phoneField;
    m_phoneField.placeholder = @"请输入您的邀请码";
    [label1Container addSubview:m_phoneField];
    
    UIButton *btnNext = BUTTON_CUSTOM(180);
    [btnNext setTitle:@"确定" forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(doSure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNext];
    
}

- (void)doTapss:(UIGestureRecognizer *)tap{
    NSLog(@"隐藏键盘");
    UIView *firstResponse = [self.view findFirstResponder];
    [firstResponse resignFirstResponder];
}

- (void)doSure
{
    [GlobalVar instance].registerInfo.invitecode = field.text;
    [self.navigationController popViewControllerAnimated:YES];
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
