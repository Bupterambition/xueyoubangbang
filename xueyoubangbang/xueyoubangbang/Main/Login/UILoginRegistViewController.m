//
//  UILoginRegistViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UILoginRegistViewController.h"
#import "UILoginVerifyViewController.h"

@interface UILoginRegistViewController ()
{
    UITableView *table;
    UITextField *field1;
    UITextField *field2;
}
@end

@implementation UILoginRegistViewController

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
    
    [self createViews];
}

#define TextFieldTag 10001
#define CELL_HEIGHT 50.0f
#define CELL_COUNT 3
- (void)createViews
{
    
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"注册帮帮账号";
    
    //隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTaps:)];
    [self.view addGestureRecognizer:tap];
    
    //输入框
    table = CREATE_TABLE(UITableViewStylePlain);
    table.frame = CGRectMake(0, 10, table.frame.size.width, table.frame.size.height);
    table.scrollEnabled = NO;
    table.allowsSelection = NO;
    [self.view addSubview:table];
    
    //其他方式Label
    UILabel *l = [[UILabel alloc] init];
    l.frame = CGRectMake(0, 180, SCREEN_WIDTH, 25);
    l.textAlignment = NSTextAlignmentCenter;
    l.textColor = [UIColor blackColor];
    l.text = @"请勿设置过于简单的密码";
    [self.view addSubview:l];
    
    //按钮
    UIButton *btnNext = BUTTON_CUSTOM(208);
    
    [btnNext setTitle:@"下一步" forState:UIControlStateNormal];
    //    [m_loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnNext addTarget:self action:@selector(doNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNext];
    
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(doNext)];
    self.navigationItem.rightBarButtonItem = rightBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
//    UIImage *originBackImage = [UIImage imageNamed:@"ic_back_nor"];
//    self.navigationController .navigationBar.backIndicatorImage = originBackImage;
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = originBackImage;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CELL_COUNT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UITextField *field = [[UITextField alloc] init];
        field.frame = CGRectMake(60, 0, 200, CELL_HEIGHT);
        field.tag = TextFieldTag;
        [cell.contentView addSubview:field];
        
    }
    UITextField *fd = (UITextField *)[ cell viewWithTag:TextFieldTag ];
    if(indexPath.row == 0){
        cell.imageView.image = [UIImage imageNamed:@"ic_user"];
        fd.placeholder = @"输入您的昵称";
        fd.secureTextEntry = YES;
    }
    else if(indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"ic_password"];
        fd.placeholder = @"设置登录密码";
        fd.secureTextEntry = NO;
    }
    else if(indexPath.row == 2){
        cell.imageView.image = [CommonMethod createImageWithColor:[UIColor clearColor] size:CGSizeMake(60, CELL_HEIGHT)];
        fd.placeholder = @"填写您的邀请码(可获得奖励20积分)";
        fd.secureTextEntry = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)doTaps:(UIGestureRecognizer *)tap{
    NSLog(@"隐藏键盘");
    UIView *firstResponse = [self.view findFirstResponder];
    [firstResponse resignFirstResponder];
}

- (void)doNext
{
    [GlobalVar registerInfo].phone =
    [self.navigationController pushViewController:[[UILoginVerifyViewController alloc] init] animated:YES];
}

- (void)doBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification{
    //    myScrollView.contentSize = CGSizeMake(320, 800);
    //    myScrollView.userInteractionEnabled = YES;
}

-(void)keyboardWillHide:(NSNotification *)notification{
    //    myScrollView.contentSize = myScrollView.bounds.size;
    //    myScrollView.contentOffset = CGPointMake(0, 0);
    
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
