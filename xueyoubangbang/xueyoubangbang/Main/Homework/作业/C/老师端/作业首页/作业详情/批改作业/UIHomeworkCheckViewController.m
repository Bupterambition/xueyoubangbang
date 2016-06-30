//
//  UIHomeworkCheckViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkCheckViewController.h"
#import "UIHomeworkViewModel.h"
#import "UIHomeworkCheckCell.h"
#import "UIHomeworkCheckDetailViewController.h"
#import "UIHomeworkUnfinishViewController.h"
#import "MessageFinishCell.h"

@interface UIHomeworkCheckViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *table;
@end

@implementation UIHomeworkCheckViewController{
    NSArray *homeworks;
}
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self.view addSubview:self.table];
    [self initIvar];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getAllStudentHomeworkDone];
}

- (void)viewWillLayoutSubviews{
    self.table.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - kNavigateBarHight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - init Method
- (void)initView{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"批改作业";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"谁还没提交" style:UIBarButtonItemStylePlain target:self action:@selector(getUnfinish)];
}
- (void)initIvar{
    homeworks = [NSArray array];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return homeworks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_ifMessage) {
        MessageFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageFinishCell"];
        [cell loadData:homeworks[indexPath.row] withIndex:indexPath];
        return cell;
    }
    else{
        UIHomeworkCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeworkCheckCell"];
        [cell loadData:homeworks[indexPath.row] withHomeworkTitle:_homeworkTitle];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_ifMessage) {
        UIHomeworkCheckDetailViewController *vc = [[UIHomeworkCheckDetailViewController alloc] initWithHomework:homeworks[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    UIHomeworkCheckDetailViewController *vc = [[UIHomeworkCheckDetailViewController alloc] initWithHomework:homeworks[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
#pragma mark - event response
- (void)getAllStudentHomeworkDone{
    [UIHomeworkViewModel getFinishhomeworkListWithParams:@{@"homeworkid":_homeworkid,@"finish":@1} withCallBack:^(NSArray *Students) {
        if (Students !=nil) {
            homeworks = Students;
            [self.table reloadData];
        }
        [self.table.legendHeader endRefreshing];
    }];
}

- (void)getUnfinish{
    UIHomeworkUnfinishViewController *vc = [[UIHomeworkUnfinishViewController alloc] init];
    vc.homeworkid = _homeworkid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE(UITableViewStylePlain);
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerNib:[UINib nibWithNibName:@"UIHomeworkCheckCell" bundle:nil] forCellReuseIdentifier:@"UIHomeworkCheckCell"];
        [_table registerNib:[UINib nibWithNibName:@"MessageFinishCell" bundle:nil] forCellReuseIdentifier:@"MessageFinishCell"];
        if (_ifMessage) {
            _table.rowHeight = 74;
        }
        else{
            _table.rowHeight = 55;
        }
        // 添加传统的下拉刷新
        [_table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getAllStudentHomeworkDone)];
    }
    return _table;
}
@end
