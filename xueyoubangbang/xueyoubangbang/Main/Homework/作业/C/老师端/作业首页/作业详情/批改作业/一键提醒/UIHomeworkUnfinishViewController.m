//
//  UIHomeworkUnfinishViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkUnfinishViewController.h"
#import "UIHomeworkViewModel.h"
#import "CheckHomeWorkStudent.h"
#import "MBProgressHUD+MJ.h"
#import "UnfinishedCell.h"

@interface UIHomeworkUnfinishViewController ()<UITableViewDataSource,UITableViewDelegate,UnfinishedCellDelegate>
@property (nonatomic, strong) UITableView *table;

@end

@implementation UIHomeworkUnfinishViewController{
    NSArray *homeworks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    [self.view addSubview:self.table];
    [self initIvar];
    [self initNav];
    [self loadUnfinishStudents];
}


- (void)viewWillLayoutSubviews{
    self.table.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT-64);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - init Method
- (void)initNav{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"一键提醒" style:UIBarButtonItemStylePlain target:self action:@selector(doAlert)];
}
- (void)initIvar{
    homeworks = [NSArray array];
}

- (void)loadUnfinishStudents{
    [UIHomeworkViewModel getFinishhomeworkListWithParams:@{@"homeworkid":_homeworkid,@"finish":@0} withCallBack:^(NSArray *Students) {
        if (Students !=nil) {
            homeworks = Students;
            [self.table reloadData];
        }
        [self.table.legendHeader endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return homeworks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UnfinishedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnfinishedCell"];
    cell.currentIndex = indexPath;
    [cell loadData:homeworks[indexPath.row]];
    cell.unfinishedCellDelegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - UnfinishedCellDelegate
- (void)didTouchNotificationBtn:(NSIndexPath*)index{
    CheckHomeWorkStudent *temp = homeworks[index.row];
    [UIHomeworkViewModel RemindHomeworkSubmitWithParams:@{@"homeworkid":_homeworkid,@"userid":temp.userid} withCallBack:^(BOOL success) {
        if (success) {
            [MBProgressHUD showSuccess:@"已提醒"];
        }
        else{
            [MBProgressHUD showError:@"已经提醒"];
        }
    }];
}
#pragma mark - event response
- (void)doAlert{
    [UIHomeworkViewModel QuickRemindWithParams:@{@"homeworkid":_homeworkid} withCallBack:^(BOOL success) {
        if (success) {
            [MBProgressHUD showSuccess:@"提醒成功"];
        }
        else{
            [MBProgressHUD showError:@"提醒失败"];
        }
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
        _table.rowHeight = 45;
        [_table registerNib:[UINib nibWithNibName:@"UnfinishedCell" bundle:nil] forCellReuseIdentifier:@"UnfinishedCell"];
        [_table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadUnfinishStudents)];
    }
    return _table;
}
@end
