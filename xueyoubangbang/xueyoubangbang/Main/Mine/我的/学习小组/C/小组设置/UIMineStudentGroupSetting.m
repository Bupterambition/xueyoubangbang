//
//  StudentGroupSetting.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/1.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//
#define DissolveGroupTag 10001
#define ModifyGroupTag   10002


#import "UIMineStudentGroupSetting.h"
#import "StudentGroupViewModel.h"
#import "MBProgressHUD+MJ.h"
#import "UIMineNewStudentsJoinVC.h"
#import "UIMineDeleteStudentViewController.h"
@interface UIMineStudentGroupSetting ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation UIMineStudentGroupSetting{
    NSArray *titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    [self initTableView];
    self.title = @"小组设置";
    titles = @[@[@"修改小组名称",@"小组ID",@"新同学申请"], @[@"成员管理",@"解散小组"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - init Method
- (void)initTableView{
    self.tableView = CREATE_TABLE(UITableViewStylePlain);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0? 3:2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0?5:20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Setting"];
    cell.textLabel.text = titles[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 35)];
                nameLabel.text = _groupinfo.groupname;
                nameLabel.textColor = [UIColor lightGrayColor];
                nameLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:nameLabel];
                nameLabel.center = CGPointMake(SCREEN_WIDTH - 130, 20);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 1:
            {
                UILabel *groupID = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 38)];
                groupID.text = [NSString stringWithFormat:@"%ld",_groupinfo.groupid];
                groupID.textAlignment = NSTextAlignmentRight;
                groupID.textColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:groupID];
                groupID.center = CGPointMake(SCREEN_WIDTH - 130, 23);
                
                UILabel *groupIntro = [[UILabel alloc]initWithFrame:CGRectMake(16, 20, 120, 35)];
                groupIntro.text = @"新同学通过ID加入小组";
                groupIntro.textAlignment = NSTextAlignmentLeft;
                groupIntro.textColor = [UIColor lightGrayColor];
                groupIntro.font = [UIFont systemFontOfSize:10];
                [cell.contentView addSubview:groupIntro];
            }
                break;
            case 2:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self modifyGroup];
                break;
            case 2:
                [self doNewMemberJoinin];
                break;
            default:
                break;
        }
    }
    else{
        switch (indexPath.row) {
//            case 0:
//                [self doShare];
//                break;
            case 0:
                [self deleteStudent];
                break;
            default:
                [self dissolveGroup];
                break;
        }
    }
}

#pragma mark - UIAlertViewdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == DissolveGroupTag) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            [StudentGroupViewModel dissolveGroup:@{@"groupid":[NSNumber numberWithInteger:_groupinfo.groupid],@"teacherid":[NSNumber numberWithInteger:_groupinfo.teacherid]} withCallBack:^(BOOL success) {
                if (success) {
                    [MBProgressHUD showSuccess:@"已解散小组"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }
    }
    else if (alertView.tag == ModifyGroupTag){
        if (buttonIndex == [alertView cancelButtonIndex]) {
            [StudentGroupViewModel modifyGroupName:@{@"groupid":[NSNumber numberWithInteger:_groupinfo.groupid],@"userid":[NSNumber numberWithInteger:_groupinfo.teacherid],@"groupname":[alertView textFieldAtIndex:0].text} withCallBack:^(BOOL success) {
                if (success) {
                    [MBProgressHUD showSuccess:@"修改成功"];
                    _groupinfo.groupname = [alertView textFieldAtIndex:0].text;
                    [self.tableView reloadData];
                }
            }];
        }
    }
}

#pragma mark - event respond
/**
 *  修改学习小组名字
 */
- (void)modifyGroup{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"修改学习小组" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = ModifyGroupTag;
    [alert show];
}
/**
 *  新同学申请
 */
- (void)doNewMemberJoinin{
    UIMineNewStudentsJoinVC *vc = [[UIMineNewStudentsJoinVC alloc]init];
    vc.groupinfo = self.groupinfo;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  解散小组
 */
- (void)dissolveGroup{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要解散该作业小组" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = DissolveGroupTag;
    [alert show];
}

- (void)deleteStudent{
    UIMineDeleteStudentViewController *vc = [[UIMineDeleteStudentViewController alloc] init];
    vc.groupinfo = _groupinfo;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
