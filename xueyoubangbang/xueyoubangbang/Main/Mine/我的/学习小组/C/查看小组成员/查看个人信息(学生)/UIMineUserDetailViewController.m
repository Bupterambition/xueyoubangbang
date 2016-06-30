//
//  UIMineUserDetailViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/20.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineUserDetailViewController.h"

#import "StudentGroupViewModel.h"
#import "UIMineCreatStudentViewController.h"
#import "MClass.h"
#import "UIMineClassIndexViewController.h"
#import "UIFriendsViewController.h"
#import "UIMinePersonalIndexViewController.h"
#import "UIMineCell.h"
#import "UILoginViewController.h"
#import "MainTabViewController.h"
#import "UISettingViewController.h"
#import "UIMineNoteViewController.h"
#import "UIHomeworkApplyGroupsForsFirst.h"
#import "UIMineKnowledageViewControllerFors.h"
#import "UIHomeworkViewModel.h"
@interface UIMineUserDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView *top;
    UITableView *table;
}

@end
typedef NS_ENUM(NSInteger, TopTag){
    HEADER    = 10000,
    NAMELABEL = 10001,
    CLASSLABEL= 10002
};

@implementation UIMineUserDetailViewController{
    NSMutableArray *classArr;//公立学校
    NSMutableArray *classArr2;//辅导学校
    UIImageView *header;
    UILabel *nameLabel;
    UILabel *classLabel;
    UIButton *settingButton;
}
#pragma mark - life method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self judgeFriend];
    [self createViews];
    [self loadData];
    [self updateUserInfo];
    [self friendInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [table reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillDisappear:animated];
}
#pragma mark - init Method
- (void)updateUserInfo{
    [header sd_setImageWithURL:[NSURL URLWithString:UrlResString(self.mUser.header_photo)] placeholderImage:DEFAULT_HEADER];
    
    nameLabel.text = self.mUser.username;
    classLabel.text = classArr.count == 0?self.mUser.schoolinfo:[(MClass*)classArr[0] class_name];
}
- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    
    [self createTop];
    table = CREATE_TABLE(UITableViewStyleGrouped);
    table.delegate = self;
    table.dataSource = self;
    table.scrollEnabled = YES;
    table.allowsSelection = NO;
    //CGFloat tableY =  top.frame.size.height + top.frame.origin.y;
    table.frame = CGRectMake(0,-20, SCREEN_WIDTH , SCREEN_HEIGHT);
    [self.view addSubview:table];
}

- (void)createTop
{
    CGFloat const topHeight = 180 + 44 + 5;
    CGFloat const padding = 5;
    top = [[UIView alloc] init];
    top.frame = CGRectMake(0, 0 , SCREEN_WIDTH, topHeight);
    top.backgroundColor = STYLE_COLOR;
    
    settingButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    [settingButton setTitle:@"加为好友" forState:UIControlStateNormal];
//    settingButton.backgroundColor = [UIColor blackColor];
    [settingButton addTarget:self action:@selector(doSendAddFriendReq) forControlEvents:UIControlEventTouchUpInside];
    settingButton.center = CGPointMake(SCREEN_WIDTH - 50, 50);
    settingButton.tintColor = [UIColor whiteColor];
    [top addSubview:settingButton];
    
    header = [[UIImageView alloc] init];
    header.tag = HEADER;
    
    header.frame = CGRectMake(0, 0, 120, 120);
    header.center = CGPointMake(SCREEN_WIDTH/2, 80+20);
    header.layer.masksToBounds = YES;
    header.layer.cornerRadius = 60;
    header.layer.borderWidth = 4;
    header.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [top addSubview:header];
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.frame = CGRectMake(topHeight + padding, 0, 100, 20);
    
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.center = CGPointMake(SCREEN_WIDTH/2, 135+44);
    nameLabel.tag = NAMELABEL;
    [top addSubview:nameLabel];
    
    classLabel = [[UILabel alloc] init];
    classLabel.frame = CGRectMake(topHeight + padding, nameLabel.frame.origin.y + nameLabel.frame.size.height + padding, 200, 15);
    classLabel.font = [UIFont systemFontOfSize:12];
    classLabel.adjustsFontSizeToFitWidth = YES;
    classLabel.textColor = [UIColor whiteColor];
    classLabel.textAlignment = NSTextAlignmentCenter;
    classLabel.center = CGPointMake(SCREEN_WIDTH/2,160+44);
    
    classLabel.tag = CLASSLABEL;
    [top addSubview:classLabel];
    
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return classArr2.count + 1;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 5 + 180 + 44;
    }
    else
        return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return top;
    }
    return nil;
}


#define ivTag 10000
#define lb1Tag 10001
#define lb2Tag 10002
#define rightLable1Tag 10000
#define rightLable2Tag 10001
#define leftLabelTag 10002
#define middleLabelTag 10003
#define cell_h 44
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier2"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier2"];
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.frame = CGRectMake(20, 0, 80, cell_h);
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.tag = leftLabelTag;
        [cell.contentView addSubview:leftLabel];
        
        UIView *sep = [[UIView alloc] init];
        sep.backgroundColor = VIEW_BACKGROUND_COLOR;
        sep.frame = CGRectMake([leftLabel rightX] + 5, 10, 1, cell.frame.size.height - 20);
        [cell.contentView addSubview:sep];
        
        UILabel *middelLabel = [[UILabel alloc] init];
        middelLabel.frame = CGRectMake([sep rightX] + 10, 0, 180, cell_h);
        middelLabel.textAlignment = NSTextAlignmentLeft;
        middelLabel.tag = middleLabelTag;
        [cell.contentView addSubview:middelLabel];
        middelLabel.font = FONT_CUSTOM(12);
    }
    if (indexPath.row == 0) {
        ((UILabel*)[cell.contentView viewWithTag:leftLabelTag]).text = @"帮帮号";
        ((UILabel*)[cell.contentView viewWithTag:middleLabelTag]).text = self.userid;
    }
    else{
        ((UILabel*)[cell.contentView viewWithTag:leftLabelTag]).text = @"学习小组";
        ((UILabel*)[cell.contentView viewWithTag:middleLabelTag]).text = [(StudentGroup*)classArr2[indexPath.row-1] groupname];
    }
    return cell;
}

#pragma mark - event respont
- (void)judgeFriend{
    [AFNetClient GlobalGet:kUrlJudgeFriend parameters:@{@"friendid":self.userid,@"userid":UserID} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        if(isUrlSuccess(dataDict))
        {
            if ([dataDict[@"data"][@"isfriend"] isEqual:@"0"]) {
                settingButton.hidden = NO;
            }
            else{
                settingButton.hidden = YES;
            }
        }
        else
        {
            settingButton.hidden = YES;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [CommonMethod showAlert:@"发送失败"];
    }];
}

/**
 *  加入学习小组
 */
- (void)joinStudentGroup{
    UIHomeworkApplyGroupsForsFirst *vc = [[UIHomeworkApplyGroupsForsFirst alloc] initWithNibName:@"UIHomeworkApplyGroupsForsFirst" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 *  发送添加好友请求
 *
 *  @param user 用户
 */
- (void)doSendAddFriendReq
{
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    [AFNetClient GlobalGet:kUrlAddFriendReq parameters:@{@"id":self.userid} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        if(isUrlSuccess(dataDict))
        {
            [CommonMethod showAlert:@"发送成功"];
        }
        else
        {
            [CommonMethod showAlert:urlErrorMessage(dataDict)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [CommonMethod showAlert:@"发送失败"];
    }];
}
/**
 *  获取用户信息
 *
 *  @param userid 用户id
 */
- (void)friendInfo{
    weak(weakself);
    [AFNetClient GlobalGet:kUrlGetUserInfo parameters:@{@"userid":self.userid} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        
        if(isUrlSuccess(dataDict)){
            weakself.mUser = [MUser objectWithKeyValues:[dataDict objectForKey:@"user"]];
            if(weakself.mUser == nil){
                [CommonMethod showAlert:@"未找到用户"];
            }
            else{
                [weakself updateUserInfo];
            }
        }
        else{
            [CommonMethod showAlert:urlErrorMessage(dataDict)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        [CommonMethod showAlert:@"网络异常"];
    }];
}
/**
 *  请求数据
 */
- (void)loadData
{
    //测试
    [AFNetClient GlobalGet:kUrlGetAllUserClass parameters:@{@"id":self.userid,@"userkey":[GlobalVar instance].user.key} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict)
     {
         NSLog(@"%@ = %@",kUrlGetUserClass,dataDict);
         NSArray *list = [dataDict objectForKey:@"list"];
         NSMutableArray *l = [NSMutableArray array];
         for (NSDictionary *dic in list) {
             MClass *m = [MClass objectWithDictionary:dic];
             if ([m.class_type isEqualToString:@"0"] && l.count==0)
             {
                 [l addObject:m];
                 [GlobalVar instance].myClass = m;
             }
         }
         classArr = l;
         [table reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [CommonMethod showAlert:@"服务异常"];
     }];
    //V2
    if ([rolesUser isEqualToString:roleStudent]) {
        [self getAddedGroups];
    }
    else{
        [StudentGroupViewModel GetStudentGroupListWithCallBack:^(NSArray *groups) {
            if (groups != nil) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.teacherid = %ld",[UserID integerValue]];
                NSArray *tempSearchArray = [groups filteredArrayUsingPredicate:predicate];
                //classArr2 = [NSMutableArray arrayWithArray:tempSearchArray];
                [table reloadData];
            }
        }];
    }
    
}
- (void)getAddedGroups{
    [UIHomeworkViewModel getstudentGroupListWithParams:@{@"studentid":self.userid} withCallBack:^(NSArray *Students) {
        if (Students != nil) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.teacherid = %ld",[UserID integerValue]];
            NSArray *tempSearchArray = [Students filteredArrayUsingPredicate:predicate];
           // classArr2 = [NSMutableArray arrayWithArray:tempSearchArray];
            [table reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
