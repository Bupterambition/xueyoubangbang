//
//  UIMineSystemSettingViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/27.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineSystemSettingViewController.h"
#import "UIMineClassIndexViewController.h"
#import "ClassEditView.h"
#import "MClass.h"
#import "UIMineCell.h"
#import "UIMineModifyUsernameViewController.h"
#import "UIPhoneViewController.h"
#import "UIMineModifyQQ.h"
#import "UIModifyPassword.h"
#import "VPImageCropperViewController.h"
#import "UILoginViewController.h"
#import "MainTabViewController.h"
#import "PrivateClassEditView.h"
#import "UIAboutViewController.h"
#import "UISettingMessageViewController.h"
#import "MBProgressHUD+MJ.h"
@interface UIMineSystemSettingViewController ()
{
    UITableView *table;
    NSMutableArray *classArr;//公立学校
    NSMutableArray *classArr2;//辅导学校
    NSArray *section1Arr;
    NSArray *sectionForStudent;
}
@end

@implementation UIMineSystemSettingViewController
- (id)init
{
    self = [super init];
    if(self){
        self.hidesBottomBarWhenPushed = YES;
        section1Arr = @[@[@"消息提醒"],@[@"手机号",@"QQ",@"修改密码"],@[@"清除缓存",@"关于学有帮帮",@"退出登录"]];
        sectionForStudent = @[@[@"消息提醒"],@[@"手机号",@"QQ",@"修改密码"],@[@"清除缓存",@"关于学有帮帮",@"退出登录"]];
        classArr = [NSMutableArray array];
        classArr2 = [NSMutableArray array];
    }
    return self;
}
#pragma mark - life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self loadData];
}
#pragma mark - init Method

- (void)loadData
{
    [AFNetClient GlobalGet:kUrlGetAllUserClass parameters:@{@"id":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict)
     {
         NSLog(@"%@ = %@",kUrlGetUserClass,dataDict);
         NSArray *list = [dataDict objectForKey:@"list"];
         for (NSDictionary *dic in list) {
             MClass *m = [MClass objectWithDictionary:dic];
             [GlobalVar instance].myClass = m;
             [GlobalVar instance].user.schoolinfo = m.class_name;
         }
         [table reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [CommonMethod showAlert:@"服务异常"];
     }];
    
}

- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"设置";
    table = CREATE_TABLE(UITableViewStylePlain);
    table.delegate = self;
    table.dataSource = self;
    table.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - kNavigateBarHight);
    table.rowHeight = 45;
    [self.view addSubview:table];
}

#pragma mark - event Respont

- (void)doLogout
{
    [GlobalVar instance].user = nil;
    [GlobalVar instance].header = nil;
    [self presentViewController:[[UICustomNavigationViewController alloc] initWithRootViewController:[[UILoginViewController alloc]init]] animated:YES completion:nil];
}


#pragma mark - UITableViewDataSource and UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if (ifRoleTeacher) {
                return [section1Arr[1] count];
            }
            else
                return [sectionForStudent[1] count];
            
        case 2:
            if (ifRoleTeacher) {
                return [section1Arr[2] count];
            }
            else
                return [sectionForStudent[2] count];
        default:
            return 1;
            break;
    }
}

#define ivTag 10000
#define lb1Tag 10001
#define lb2Tag 10002
#define rightLable1Tag 10000
#define rightLable2Tag 10001
#define leftLabelTag 10002
#define middleLabelTag 10003
#define cell_h 44
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier ;
    UITableViewCell *cell;
    if(indexPath.section == 0){
        CellIdentifier = @"cellIdentifier1";
        cell  = [table dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = [section1Arr[indexPath.section] objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 1){
        CellIdentifier = @"cellIdentifier1";
        cell  = [table dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (ifRoleTeacher) {
            cell.textLabel.text = [section1Arr[1] objectAtIndex:indexPath.row];
            NSString *detail;
            switch (indexPath.row) {
                case 0:
                    detail = [GlobalVar instance].user.phone;
                    break;
                case 1:
                    detail = [GlobalVar instance].user.qq;
                    break;
                case 2:
                    detail = nil;
                    break;
                default:
                    break;
            }
            if([CommonMethod isBlankString:detail])
            {
                if(indexPath.row !=2)
                {
                    detail = @"去绑定";
                }
            }
            cell.detailTextLabel.text = detail;
        }
        else{
            cell.textLabel.text = [sectionForStudent[1] objectAtIndex:indexPath.row];
            NSString *detail;
            switch (indexPath.row) {
                case 0:
                    detail = [GlobalVar instance].user.phone;
                    break;
                case 1:
                    detail = [GlobalVar instance].user.qq;
                    break;
                case 2:
                    detail = nil;
                    break;
                default:
                    break;
            }
            if([CommonMethod isBlankString:detail])
            {
                if(indexPath.row !=2)
                {
                    detail = @"去绑定";
                }
            }
            cell.detailTextLabel.text = detail;
        }
    }
    else{
        CellIdentifier = @"cellIdentifier1";
        cell  = [table dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = [section1Arr[2] objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1fM",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
        }
        if (indexPath.row == 2) {
            [cell.detailTextLabel setTextColor:[UIColor redColor]];
        }
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        [self.navigationController pushViewController:[[UISettingMessageViewController alloc] init] animated:YES];
    }
    else if(indexPath.section == 1){
        UIViewController *ctrl ;
        switch (indexPath.row) {
            case 0:
                ctrl = [[UIPhoneViewController alloc] init];
                [self.navigationController pushViewController:ctrl animated:YES];
                break;
            case 1:
                ctrl = [[UIMineModifyQQ alloc] init];
                [self.navigationController pushViewController:ctrl animated:YES];
                break;
            case 2:
                ctrl = [[UIModifyPassword alloc] init];
                [self.navigationController pushViewController:ctrl animated:YES];
                break;
            default:
                break;
        }
    }
    else{
        if (indexPath.row == 0) {
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [MBProgressHUD showSuccess:@"清理完毕"];
                [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
        else if(indexPath.row == 1){
            [self.navigationController pushViewController:[[UIAboutViewController alloc] init] animated:YES];
        }
        else{
            [self doLogout];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
