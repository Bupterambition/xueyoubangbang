//
//  UIMineGroupViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/27.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineGroupViewController.h"
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
#import "UIMineNoteAllViewController.h"
@interface UIMineGroupViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *table;

@end

@implementation UIMineGroupViewController{
    NSMutableArray *classArr2;//辅导学校
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
    [self loadData];
}

- (void)viewWillLayoutSubviews{
    self.table.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT - kNavigateBarHight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - init Method
- (void)initView{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"作业小组";
    if (ifRoleStudent) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"my_group_add") style:UIBarButtonItemStylePlain target:self action:@selector(joinStudentGroup)];
    }
    else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"my_group_add") style:UIBarButtonItemStylePlain target:self action:@selector(creatStudentGroup)];
    }
}
- (void)initIvar{
    classArr2 = [NSMutableArray array];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return classArr2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"cellIdentifier1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    cell.backgroundColor = VIEW_BACKGROUND_COLOR;
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    if ( indexPath.row == classArr2.count) {
        cell.textLabel.text = @"添加";
        cell.imageView.image = IMAGE(@"my_group_add");
    }
    else {
        StudentGroup *m = [classArr2 objectAtIndex:indexPath.row];
        cell.textLabel.text = m.groupname;
        NSString *testImaName = [NSString stringWithFormat:@"teamlist_%@",[m getSubject]];
        cell.imageView.image = IMAGE(testImaName);
//        cell.imageView.layer.masksToBounds = YES;
//        cell.imageView.layer.cornerRadius = CGRectGetHeight(cell.imageView.frame)/2;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIMineClassIndexViewController *ctrl = [[UIMineClassIndexViewController alloc] init];
    ctrl.groupinfo = classArr2[indexPath.row];
    ctrl.classinfo = nil;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
#pragma mark - event respont
/**
 *  加入学习小组
 */
- (void)joinStudentGroup{
    UIHomeworkApplyGroupsForsFirst *vc = [[UIHomeworkApplyGroupsForsFirst alloc] initWithNibName:@"UIHomeworkApplyGroupsForsFirst" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 *  创建学习小组
 */
- (void)creatStudentGroup{
    UIMineCreatStudentViewController *vc = [[UIMineCreatStudentViewController alloc]initWithNibName:@"UIMineCreatStudentViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 *  请求数据
 */
- (void)loadData
{
    weak(weakself);
    //V2
    if ([rolesUser isEqualToString:roleStudent]) {
        [self getAddedGroups];
    }
    else{
        [StudentGroupViewModel GetStudentGroupListWithCallBack:^(NSArray *groups) {
            if (groups != nil) {
                classArr2 = [NSMutableArray arrayWithArray:groups];
                [weakself.table reloadData];
            }
            [weakself.table.header endRefreshing];
        }];
    }
    
}
- (void)getAddedGroups{
    weak(weakself);
    [UIHomeworkViewModel getstudentGroupListWithParams:@{@"studentid":[GlobalVar instance].user.userid} withCallBack:^(NSArray *Students) {
        if (Students != nil) {
            classArr2 = [NSMutableArray arrayWithArray:Students];
            [weakself.table reloadData];
        }
        else{
            [classArr2 removeAllObjects];
            [weakself.table reloadData];
        }
        [weakself.table.header endRefreshing];
    }];
}
#pragma getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE(UITableViewStylePlain);
        _table.delegate = self;
        _table.dataSource = self;
        _table.rowHeight = 65;
        // 添加传统的下拉刷新
        [_table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    return _table;
}

@end
