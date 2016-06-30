//
//  UIHomeworkDetailHomeworkViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/13.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkDetailHomeworkViewController.h"
#import "UIHomeworkAddCell.h"
#import "NSDate+Format.h"
#import "UIHomeworkBottomView.h"
#import "NewHomeWorkSend.h"
#import "NewHomeworkFileSend.h"
#import "UFOFeedImageViewController.h"
#import "UIHomeworkCheckDetailCell.h"
#import "MBProgressHUD+MJ.h"
#import "UIHomeworkViewModel.h"
#import "NewHomeworkItem.h"
#import "UIHomeworkCheckViewController.h"
#import "UIHomeworkNetClient.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <objc/runtime.h>
typedef NS_ENUM(NSInteger, ADDHOMEWORK){
    HOMEWORKTITLE,
    SUBMMITTIME,
    KNOWLEDGE
};
typedef NS_ENUM(NSInteger, BottomMethod){
    NoSelectorItem = 0,
    SelectorItem,
    Method_Cancel
};
typedef NS_ENUM(NSInteger, CELLHEIGHT){
    NOPICANDAUDIO = 60,
    ONELINEPIC = 178,
    TWOLINEPIC = 267
};

@interface UIHomeworkDetailHomeworkViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIHomeworkCheckDetailDelegate>
@property (nonatomic, strong) UITableView *table;

@end

@implementation UIHomeworkDetailHomeworkViewController{
    NSArray *cellTitles;
    NSArray *homeworkData;
    NSString *homeworkTitle;
}
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initIvar];
    [self initNav];
    [self loadDetailHomeWork];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [UIHomeworkNetClient cancelRequest];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   // [self tryMember];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews{
    [self initTable];
}
#pragma mark - init Method
- (void)initView{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"作业详情";
    [self.view addSubview:self.table];
}
- (void)initNav{
    UIBarButtonItem *right_check = [[UIBarButtonItem alloc]initWithTitle:@"批改作业" style:UIBarButtonItemStylePlain target:self action:@selector(checkForHomework)];
    self.navigationItem.rightBarButtonItem = right_check;
}
- (void)initIvar{
    cellTitles = @[@"作业题目",@"提交时间",@"作业小组",@"知识点"];
    
}
/**
 *  测试方法，没有用
 */
- (void)tryMember
{
    unsigned int count = 0;
    Ivar *members = class_copyIvarList([self.table class], &count);
    for (int i = 0 ; i < count; i++) {
        Ivar var = members[i];
        const char *memberName = ivar_getName(var);
        const char *memberType = ivar_getTypeEncoding(var);
        if ([[NSString stringWithUTF8String:memberName] isEqualToString:@"_reusableTableCells"]) {
            NSLog(@"%@",object_getIvar(self.table,var));
        }
        NSLog(@"%s----%s", memberName, memberType);
    }
}
- (void)initTable{
    self.table.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT-64);
}
- (void)loadDetailHomeWork{
    weak(weakself);
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    [UIHomeworkViewModel getHomeworkDetailWithParams:@{@"homeworkid":_home_work_id} withCallBack:^(NSArray *homeWorkDetail,BOOL noNet) {
        [MBProgressHUD hideHUDForView:weakself.view animated:YES];
        if (homeWorkDetail) {
            homeworkData = [NSArray arrayWithArray:homeWorkDetail];
            [weakself.table reloadData];
        }
        else{
            if (!noNet) {
                [MBProgressHUD showError:@"该作业内容不存在"];
            }
        }
    }];
}
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 45;
    }
    else{
        CGFloat collectionHeight;
        NSInteger picNum = [(NewHomeworkItem*)(homeworkData[1][indexPath.section-1]) getPicArray].count ;
        picNum +=  [CommonMethod isBlankString:((NewHomeworkItem*)(homeworkData[1][indexPath.section-1])).audio]?0:1;
        if (picNum == 0){
            collectionHeight = 0;
        }
        else if (picNum >3){
            collectionHeight = 190;
        }
        else{
            collectionHeight = 100;
        }
        
        return collectionHeight + [tableView fd_heightForCellWithIdentifier:@"UIHomeworkCheckDetailCell" cacheByIndexPath:indexPath configuration:^(UIHomeworkCheckDetailCell *cell) {
            [cell loadItemDataForCheck:homeworkData[1][indexPath.section -1]];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + (homeworkData[1] == nil?0:[homeworkData[1] count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0?4:1;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)Cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UIHomeworkAddCell *cell = (UIHomeworkAddCell *)Cell;
        cell.title.text = cellTitles[indexPath.row];
        cell.editField.enabled = NO;
        [cell.editImageView removeFromSuperview];
        [cell loadHomeworkForTitle:homeworkData[0] withIndex:indexPath];
        if (indexPath.row == 0) {
            homeworkTitle = cell.editField.text;
        }
    }
    else{
        UIHomeworkCheckDetailCell *cell = (UIHomeworkCheckDetailCell *)Cell ;
        cell.itemNum.text = [NSString stringWithFormat:@"第%ld项",indexPath.section];
        cell.checkDetailDelegate = self;
        cell.currentIndex = indexPath;
        [cell loadItemDataForCheck:homeworkData[1][indexPath.section -1]];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIHomeworkAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeworkAddCell"];
        return cell;
    }
    else{
        UIHomeworkCheckDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeworkCheckDetailCell"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIHomeworkCheckDetailDelegate
- (void)didTouchHomeworkPic:(NSInteger)index withIndex:(NSIndexPath *)indexPath{
    UFOFeedImageViewController *vc = [[UFOFeedImageViewController alloc]initWithCheckPicArray:[(NewHomeworkItem*)(homeworkData[1][indexPath.section-1]) getPicArray] andCurrentDisplayIndex:index];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - event respond
- (void)checkForHomework{
    UIHomeworkCheckViewController *vc = [[UIHomeworkCheckViewController alloc] init];
    vc.homeworkid = self.home_work_id;
    vc.homeworkTitle = homeworkTitle;
    vc.ifMessage = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE(UITableViewStylePlain);
        _table.delegate = self;
        _table.dataSource = self;
        _table.sectionHeaderHeight = 5;
        _table.sectionFooterHeight = 5;
        _table.showsVerticalScrollIndicator = NO;
        [_table registerNib:[UINib nibWithNibName:@"UIHomeworkAddCell" bundle:nil] forCellReuseIdentifier:@"UIHomeworkAddCell"];
        [_table registerNib:[UINib nibWithNibName:@"UIHomeworkCheckDetailCell" bundle:nil] forCellReuseIdentifier:@"UIHomeworkCheckDetailCell"];
    }
    return _table;
}
@end
