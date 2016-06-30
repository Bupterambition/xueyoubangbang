//
//  UILoginRegistClassViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UILoginRegistClassViewController.h"
#import "UILoginRegistClassSearchViewController.h"
#import "UILoginRegistDoneViewController.h"
#import "ClassEditView.h"
#import "UILoginRegisterInfoDoneViewController.h"
@interface UILoginRegistClassViewController ()
{
//    UITableView *table;
//    NSString *currentSchool;
//    NSString *currentGrade;
//    NSString *currentClass;
//    
//    NSMutableArray *schoolArr;
//    NSMutableArray *gradeArr;
//    NSMutableArray *classArr;
    ClassEditView *classEditView;
}
@end

@implementation UILoginRegistClassViewController

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
}


- (void)createViews
{
    
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"班级信息";
    
    ClassEditView *classEdit = [[ClassEditView alloc]initWithFrame:CGRectMake(0, kPaddingTop, self.view.frame.size.width, 250)];
    [classEdit.btnSure removeFromSuperview];
    [classEdit.btnCancel removeFromSuperview];
    classEdit.table.backgroundColor = [UIColor clearColor];
    classEdit.backgroundColor = [UIColor clearColor];
    [self.view addSubview:classEdit];
    classEditView = classEdit;
    
    //按钮
    UIButton *btnNext = BUTTON_CUSTOM(0);
    btnNext.frame = CGRectMake(btnNext.frame.origin.x, self.view.frame.size.height - btnNext.frame.size.height - kNavigateBarHight - 50, btnNext.frame.size.width, btnNext.frame.size.height);
    [btnNext setTitle:@"下一步" forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(doNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNext];
    
    
    //隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapss)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
//    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(doNext)];
//    self.navigationItem.rightBarButtonItem = rightBar;

}

//如果不写该段甘薯，则UITableView的点击回调不会执行
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:classEditView.table] || [touch.view isDescendantOfView:classEditView.tableResult]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}

- (void)doNext
{
    if([CommonMethod isBlankString:classEditView.currentSchoolId] || [CommonMethod isBlankString:classEditView.currentGrade] || [CommonMethod isBlankString:classEditView.currentClass])
    {
        [CommonMethod showAlert:@"信息不完整"];
        return;
    }
    NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key,@"schoolid":classEditView.currentSchoolId,@"schoolname":classEditView.currentScooolName,@"classid":classEditView.currentClass,@"gradeid":classEditView.currentGrade};
    NSLog(@"kUrlSetClassInfo para = %@",para);
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    [AFNetClient GlobalGet:kUrlSetClassInfo parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        [self.navigationController pushViewController:[[UILoginRegisterInfoDoneViewController alloc] init] animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
    }];
}

- (void)doTapss
{
    [[self.view findFirstResponder] resignFirstResponder];
    [classEditView removeTableResult];
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
