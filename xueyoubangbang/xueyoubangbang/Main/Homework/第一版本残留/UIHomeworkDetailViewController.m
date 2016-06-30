//
//  UIHomeworkDetailViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkDetailViewController.h"
#import "MHomework.h"
#import "UIHomeworkDetailCellTableViewCell.h"
#import "UIQuestionAskViewController.h"
#import "UIHomeworkDetailQuestionViewController.h"
#import "MHomeworkItem.h"
#import "UIQuestionListViewController.h"
#import "UIListTableViewCell.h"
#import "AFNetClient.h"
#import "UIHomeworkDetailCell2.h"
@interface UIHomeworkDetailViewController ()
{
    UITableView *table;
    UIButton *btnFinish;
//    NSMutableArray *questionArr;
}
@end

@implementation UIHomeworkDetailViewController

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
    [self loadData];
}

- (void)loadData
{
    if(_homework == nil)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key,@"id":_homeworkid};
        [AFNetClient GlobalGet:kUrlGetHomework parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(isUrlSuccess(dataDict))
            {
                _homework = [MHomework objectWithDictionary:[dataDict objectForKey:@"homework"]];
                
                [table reloadData];
                
                if([rolesUser isEqualToString:roleStudent])
                {
                    if([_homework.status isEqualToString: @"0"])
                    {
                        [btnFinish setTitle:@"做完啦" forState:UIControlStateNormal];
                        [btnFinish addTarget:self action:@selector(doFinish) forControlEvents:UIControlEventTouchUpInside];
                    }
                    else if([_homework.status isEqualToString:@"1"])
                    {
                        [btnFinish setTitle:@"已完成" forState:UIControlStateNormal];
                        btnFinish.enabled = NO;
                    }
                    else if([_homework.status isEqualToString:@"2"])
                    {
                        [btnFinish setTitle:@"未完成" forState:UIControlStateNormal];
                        btnFinish.enabled = NO;
                    }
                    
                    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50 + kPaddingTop * 2)];
                    [footer addSubview:btnFinish];
                    table.tableFooterView = footer;
                }
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}

- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"作业详情";
    table = CREATE_TABLE(UITableViewStyleGrouped);
    table.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height - kNavigateBarHight);
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if([rolesUser isEqualToString:roleStudent])
    {
        btnFinish = BUTTON_CUSTOM(0);
        if([_homework.status isEqualToString: @"0"])
        {
            [btnFinish setTitle:@"做完啦" forState:UIControlStateNormal];
            [btnFinish addTarget:self action:@selector(doFinish) forControlEvents:UIControlEventTouchUpInside];
        }
        else if([_homework.status isEqualToString:@"1"])
        {
            [btnFinish setTitle:@"已完成" forState:UIControlStateNormal];
            btnFinish.enabled = NO;
        }
        else if([_homework.status isEqualToString:@"2"])
        {
            [btnFinish setTitle:@"未完成" forState:UIControlStateNormal];
            btnFinish.enabled = NO;
        }
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50 + kPaddingTop * 2)];
        [footer addSubview:btnFinish];
        table.tableFooterView = footer;
    }
    [self.view addSubview:table];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"问题列表" style:UIBarButtonItemStylePlain target:self action:@selector(doQuestionList)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _homework.itemlist.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
            
        default:
            return 1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}


#define rightLable1Tag 10000
#define rightLable2Tag 10001
#define leftLabelTag 10002
#define middleLabelTag 10003
#define CELL_HEIGTH 44
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        NSString *CellIdentifier = @"cellIdentifier0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *leftLabel = [[UILabel alloc] init];
            leftLabel.frame = CGRectMake(20, 0, 80, CELL_HEIGTH);
            leftLabel.textAlignment = NSTextAlignmentLeft;
            leftLabel.tag = leftLabelTag;
            [cell.contentView addSubview:leftLabel];
            
            UIView *sep = [[UIView alloc] init];
            sep.backgroundColor = VIEW_BACKGROUND_COLOR;
            sep.frame = CGRectMake([leftLabel rightX] + 5, 10, 1, cell.frame.size.height - 20);
            [cell.contentView addSubview:sep];
            
            UILabel *middelLabel = [[UILabel alloc] init];
            middelLabel.frame = CGRectMake([sep rightX] + 10, 0, 150, CELL_HEIGTH);
            middelLabel.textAlignment = NSTextAlignmentLeft;
            middelLabel.tag = middleLabelTag;
            [cell.contentView addSubview:middelLabel];

        }
        UILabel *leftLb = (UILabel *)[cell viewWithTag:leftLabelTag];
        UILabel *middleLb = (UILabel *)[cell viewWithTag:middleLabelTag];
        if(indexPath.row == 0)
        {
            leftLb.text = @"题目";
            middleLb.text = _homework.subject_name;
        }
        else if(indexPath.row == 1){
            leftLb.text = @"提交时间";
            middleLb.text = [CommonMethod formatDate:_homework.submittime outFormat:@"MM月dd日    HH:ss"];
        }
        return cell;
    }
    else{
//        NSString *CellIdentifier = @"cellIdentifier1";
////        UIHomeworkDetailCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
////        if (nil == cell) {
//        
//            UIHomeworkDetailCellTableViewCell * cell = [[UIHomeworkDetailCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            [cell.rightTopButton addTarget:self action:@selector(doAsk:) forControlEvents:UIControlEventTouchUpInside];
////        }
//        MHomeworkItem *hi = [_homework.itemlist objectAtIndex:indexPath.section - 1];
//        [cell settingData:hi];
//        cell.leftTopLabel.text = hi.title;
//        return cell;
        NSString *CellIdentifier = @"cellIdentifier1";
        UIHomeworkDetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(nil == cell)
        {
            cell = [[UIHomeworkDetailCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            if([roleStudent isEqualToString: [GlobalVar instance].user.roles])
            {
                [cell.rightTopButton setTitle:@"问一下" forState:UIControlStateNormal];
                [cell.rightTopButton addTarget:self action:@selector(doAsk:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else
        {
            cell.rightTopButton.hidden = YES;
            cell.rightIcon.hidden = YES;
        }
        cell.ifAddWorkVC = NO;
        MHomeworkItem *hi = [_homework.itemlist objectAtIndex:indexPath.section - 1];
        cell.homeworkItem = hi;
        cell.homeworkItem.subject_name = _homework.subject_name;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return CELL_HEIGTH;
    }
    return [UIHomeworkDetailCell2 cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return;
    UIHomeworkDetailQuestionViewController *ctrl = [[UIHomeworkDetailQuestionViewController alloc] init];
    ctrl.homeworkItem = [_homework.itemlist objectAtIndex:indexPath.section - 1];
    ctrl.homeworkItem.subject_name = _homework.subject_name;
    [self.navigationController pushViewController:ctrl animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)doAsk:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UIHomeworkDetailCellTableViewCell *cell = (UIHomeworkDetailCellTableViewCell *) btn.superview.superview;
    NSIndexPath *indexPath = [table indexPathForCell:cell];
    MHomeworkItem *hi = [_homework.itemlist objectAtIndex:indexPath.section - 1];
    NSLog(@"doAsk section = %ld",indexPath.section);
    NSLog(@"doAsk row = %ld",indexPath.row);
    NSLog(@"homeworkItem = %@",hi.desc);
    
    UIQuestionAskViewController *ctrl = [[UIQuestionAskViewController alloc]init];
    ctrl.homeworkItem = hi;
    ctrl.homeworkItem.subject_name = _homework.subject_name;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)doFinish
{
    [BlockAlertView alertWithTitle:nil message:@"确认提交作业？" cancelButtonWithTitle:@"取消" cancelBlock:^{
        ;
    } confirmButtonWithTitle:@"确定" confrimBlock:^{
        [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
        NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid,@"userkey": [GlobalVar instance].user.key,@"id":_homework.homework_id};
        NSLog(@"kUrlFinishHomework para = %@",para);
        [AFNetClient GlobalPost:kUrlFinishHomework parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
            [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
            NSLog(@"kUrlFinishHomework = %@",dataDict);
            if(isUrlSuccess(dataDict))
            {
                [CommonMethod showAlert:@"提交成功"];
                [btnFinish setTitle:@"已完成" forState:UIControlStateNormal];
                btnFinish.enabled = NO;
                _homework.status = @"1";
            }
            else
            {
                [CommonMethod showAlert:urlErrorMessage(dataDict)];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
            [CommonMethod showAlert:@"提交失败"];
        }];
    }];

}

- (void)doQuestionList
{
    UIQuestionListViewController *ctrl = [[UIQuestionListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
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
