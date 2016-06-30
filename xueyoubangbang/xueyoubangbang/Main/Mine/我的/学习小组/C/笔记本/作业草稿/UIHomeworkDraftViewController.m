//
//  UIHomeworkDraftViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkDraftViewController.h"
#import "UIHomeworkDraftCell.h"
#import "UIHomeworkViewModel.h"
#import "UIHomeworkAddHomeworkViewController.h"
#import "NewHomeWorkSend.h"
#import "NewHomeworkFileSend.h"
#import "MBProgressHUD+MJ.h"
@interface UIHomeworkDraftViewController ()<UITableViewDataSource,UITableViewDelegate,UIHomeworkDraftDelegate>
@property (nonatomic, strong) UITableView *table;
@end

@implementation UIHomeworkDraftViewController{
    NSMutableArray *homeworks;
    NSInteger currentPage;
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
    [self loadHomeWorkData];
}

- (void)viewWillLayoutSubviews{
    self.table.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - init Method
- (void)initView{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"作业草稿";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"add_grey") style:UIBarButtonItemStylePlain target:self action:@selector(addHomework)];
}
- (void)initIvar{
    homeworks = [NSMutableArray array];
    currentPage = 1;
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return homeworks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIHomeworkDraftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeworkDraftCell"];
    [cell loadNewHomeWork:homeworks[indexPath.row]];
    cell.currentIndexPath = indexPath;
    cell.draftDelegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self presentViewController:[[UICustomNavigationViewController alloc] initWithRootViewController:[[UIHomeworkAddHomeworkViewController alloc] initWithHomework:homeworks[indexPath.row] withIndex:indexPath]] animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
#pragma mark - UIHomeworkDraftDelegate

- (void)didTouchDraftDelete:(NSIndexPath*)currentIndexPath{
    [homeworks removeObjectAtIndex:currentIndexPath.row];
    BOOL res = [NewHomeWorkSend saveListModel:homeworks forKey:@"NewHomeWorkSend"];
    if (res) {
        NSLog(@"SUCCESS");
        [MBProgressHUD showSuccess:@"已删除该作业草稿"];
        [self.table reloadData];
    }
    else{
        NSLog(@"失败");
    }
}

#pragma mark -event respond
- (void)addHomework{
    //新入口
    [self presentViewController:[[UICustomNavigationViewController alloc] initWithRootViewController:[[UIHomeworkAddHomeworkViewController alloc] init] ] animated:YES completion:nil];
}
- (void)loadHomeWorkData{
    [homeworks removeAllObjects];
    [homeworks addObjectsFromArray:[NewHomeWorkSend readListModelForKey:@"NewHomeWorkSend"]];
    if (homeworks != nil) {
        [self.table reloadData];
    }

}

#pragma private Method
-(NSDictionary *)getPara:(NSInteger)pageIndex
{
    NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key,@"pageIndex":[NSNumber numberWithInteger:pageIndex],@"pageSize":kPageSize};
    NSLog(@"homelist para = %@",para);
    return para;
}

#pragma getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE(UITableViewStylePlain);
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerNib:[UINib nibWithNibName:@"UIHomeworkDraftCell" bundle:nil] forCellReuseIdentifier:@"UIHomeworkDraftCell"];
        _table.rowHeight = 75;
    }
    return _table;
}
@end
