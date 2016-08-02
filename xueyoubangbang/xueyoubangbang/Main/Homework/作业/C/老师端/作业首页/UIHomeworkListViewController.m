//
//  UIHomeworkListViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkListViewController.h"
#import "UIHomeworkDetailViewController.h"
#import "MHomework.h"
#import "MHomeworkItem.h"
#import "MSubject.h"
#import "UIHomeworkAddViewController.h"
#import "UIHomeworkMainCell.h"
#import "UIHomeworkBottomView.h"
#import "UIHomeworkViewModel.h"
#import "RCDraggableButton.h"
#import "UIHomeworkDraftViewController.h"
#import "UIHomeworkDetailHomeworkViewController.h"
#import "UIHomeworkAddHomeworkViewController.h"
#import "NSDate+Format.h"
#import "UIInterActAskMeViewController.h"
#import "NSString+Stackoverflow.h"
#import "YTKKeyValueStore.h"
#import "UIHomeworkListViewModel.h"
#import "ClockView.h"
typedef NS_ENUM(NSInteger, BottomMethod){
    Method_Modify = 0,
    Method_Delete,
    Method_Cancel
};
@interface UIHomeworkListViewController ()<UITableViewDelegate,UIPopCompleteDelegate,UIHomeCellMainDelegate,UIHomeworkBottomDelegate>
{
    NSInteger currentPageIndex;
    NSIndexPath *currentIndexPath;
    UIView *pickerContainer;
    UIDatePicker *datePicker;
}
@property (nonatomic, strong) UIHomeworkListViewModel *viewModel;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *backgroudView;
@property (nonatomic, strong) UIHomeworkBottomView *bottomView;
@property (nonatomic, strong) ClockView *clockView;
@end

@implementation UIHomeworkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
    [self initNav];
    [self createViews];
    [self.table.legendHeader beginRefreshing];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self newLoadHomeWork];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self pushBottomView];
}

- (void)viewWillLayoutSubviews{
    self.table.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
}
#pragma mark - init Method
- (void)initial{
    currentPageIndex = 1;
    weak(weakself);
    [RACObserve(self.viewModel, finishUpdate) subscribeNext:^(id x) {
        if ([x boolValue]) {
            [weakself.table.header endRefreshing];
            [weakself.table.footer endRefreshing];
            [weakself.table reloadData];
        }
    }];
    
    [self.viewModel.cellDelegateSignal subscribeNext:^(id x) {
        [weakself didTouchButton:x[0]];
    }];
    
    [self.viewModel.tableSubject subscribeNext:^(id x) {
        [self goToNewDetail:x];
    }];
}

- (void)initNav{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"互动圈" style:UIBarButtonItemStylePlain target:self action:@selector(goToInterAct)];
}

- (void)createViews{
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = @"作业";
    [self.view addSubview:self.table];
    //添加底部视图
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroudView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bottomView];
    
    //添加＋悬浮按钮
    weak(weakSelf);
    RCDraggableButton *avatar = [[RCDraggableButton alloc] initInView:self.view WithFrame:CGRectMake(220, 200, 60, 60)];
    [avatar setBackgroundImage:[UIImage imageNamed:@"teacher_addhomwwork"] forState:UIControlStateNormal];
    [avatar setTapBlock:^(RCDraggableButton *avatar) {
        [weakSelf goToAddHomework];
    }];
    [avatar setDragDoneBlock:nil];
    [self.clockView creatWithMainView:self.view andScrollView:self.table andDataSource:self.viewModel];
}


#pragma mark -  UITableViewDelegate Method

- (void)goToNewDetail:(NSIndexPath*)indexPath{
    UIHomeworkDetailHomeworkViewController *vc = [[UIHomeworkDetailHomeworkViewController alloc] init];
    vc.home_work_id = ((NewHomeWork*)[self.viewModel.homeworks objectAtIndex:indexPath.section]).homework_id;
    [self pushBottomView];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UIHomeCellMainDelegate
- (void)didTouchButton:(NSIndexPath *)currentIndex{
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroudView];
    currentIndexPath = currentIndex;
    if (__CGPointEqualToPoint(self.bottomView.frame.origin, CGPointMake(0, SCREEN_HEIGHT-135))) {
        self.backgroudView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 135);
        } completion:^(BOOL finished) {
            self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 135);
        }];
    }
    else{
        self.backgroudView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-135, SCREEN_WIDTH, 135);
        } completion:^(BOOL finished) {
            self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-135, SCREEN_WIDTH, 135);
        }];
    }
}
#pragma mark - UIHomeworkBottomDelegate
- (void)bottomViewMethod:(NSIndexPath*)path{
    [self pushBottomView];
    switch (path.row) {
        case Method_Modify:
            [self modifyHomework];
            break;
        case Method_Delete:
            [self deleteHomework];
            break;
        case Method_Cancel:
            
            break;
        default:
            break;
    }
}
#pragma mark - event respond
- (void)goToInterAct{
    UIInterActAskMeViewController *vc = [[UIInterActAskMeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 *  进入布置作业
 */
- (void)goToAddHomework{
    [self.navigationController pushViewController:[[UIHomeworkAddHomeworkViewController alloc] init] animated:YES];
}
/**
 *  显示提交时间
 */
- (void)showSubmitTime{
    if(pickerContainer == nil){
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.backgroundColor = [UIColor whiteColor];
        pickerContainer = [[UIView alloc] init];
        
        [pickerContainer addSubview:datePicker];
        
        UIView *topView = [[UIView alloc] init];
        [pickerContainer addSubview:topView];
        topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
        topView.backgroundColor = [UIColor grayColor];
        
        UIButton *btnComplete = [UIButton buttonWithType:UIButtonTypeCustom];
        [topView addSubview:btnComplete];
        btnComplete.frame = CGRectMake(SCREEN_WIDTH - 10 - 100, 0, 100, 49);
        [btnComplete setTitle:@"完成" forState:UIControlStateNormal];
        [btnComplete addTarget:self action:@selector(doSureTime) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [topView addSubview:btnCancel];
        btnCancel.frame = CGRectMake(10, 0, 100, 49);
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(doCancelTime) forControlEvents:UIControlEventTouchUpInside];
        
    }
    pickerContainer.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, datePicker.frame.size.height + 50);
    datePicker.frame = CGRectMake(0, 50, SCREEN_WIDTH, datePicker.frame.size.height);
    [LayerCustom showWithView:pickerContainer];
}
- (void)doSureTime{
    NewHomeWork *temp = self.viewModel.homeworks[currentIndexPath.section];
    weak(weakself);
    [UIHomeworkViewModel modifyHomeworkWithParams:@{@"teacherid":[GlobalVar instance].user.userid,@"homeworkid":temp.homework_id,@"deadline":[datePicker.date format:@"yyyy-MM-dd HH:mm:ss"]} withCallBack:^(BOOL success, NSString *newdate) {
        if (success) {
            [weakself newLoadHomeWork];
        }
    }];
    [self doCancelTime];
}

- (void)doCancelTime{
    [LayerCustom hide];;
}
- (void)modifyHomework{
    [self showSubmitTime];
}
/**
 *  删除作业
 */
- (void)deleteHomework{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"⚠️确定要删除该条作业" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    weak(weakself);
    [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(id x) {
        if ([x[1] integerValue] == [(UIAlertView*)x[0] cancelButtonIndex]) {
            NewHomeWork *temp = weakself.viewModel.homeworks[currentIndexPath.section];
            [UIHomeworkViewModel deleteHomeworkWithParams:@{@"teacherid":[GlobalVar instance].user.userid,@"homeworkid":temp.homework_id} withCallBack:^(BOOL success) {
                if (success) {
                    [weakself.viewModel.homeworks removeObjectAtIndex:currentIndexPath.section];
                    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"Xueyoubangbang.db"];
                    NSString *tableName = @"Homework_Detail_Teacher";
                    [store deleteObjectById:temp.homework_id fromTable:tableName];
                    [weakself.table reloadData];
                }
            }];
        }
    }];
}
- (void)newLoadHomeWork{
    [self.viewModel.loadCommand execute:nil];
}

- (void)newloadMoreHomeworks{
    [self.viewModel.moreLoadCommand execute:nil];
}

- (void)doTeacherAddHomework{
    UIHomeworkAddViewController *ctrl = [[UIHomeworkAddViewController alloc] init];
    ctrl.popDelegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
    //新入口
}

#pragma mark - private Method

- (void)pushBottomView{
    self.backgroudView.hidden = YES;
    weak(weakself);
    [UIView animateWithDuration:0.5 animations:^{
        weakself.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 135);
    } completion:^(BOOL finished) {
        weakself.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 135);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setter and getter
- (UIHomeworkListViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[UIHomeworkListViewModel alloc] init];
    }
    return _viewModel;
}
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE_WithoutSource(UITableViewStylePlain);
        _table.dataSource = self.viewModel;
        [_table registerNib:[UINib nibWithNibName:@"UIHomeworkMainCell" bundle:nil] forCellReuseIdentifier:@"UIHomeworkMainCell"];
        _table.rowHeight = 100;
        _table.backgroundColor = RGB(220,220,220);
        // 添加传统的下拉刷新
        [_table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(newLoadHomeWork)];
        // 添加传统的上拉刷新
        [_table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(newloadMoreHomeworks)];
        [_table.footer setStateHidden:YES];
    }
    return _table;
}
- (UIView *)backgroudView{
    if (_backgroudView == nil) {
        //添加底部视图
        _backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-135)];
        _backgroudView.alpha = 0.3;
        _backgroudView.backgroundColor = [UIColor blackColor];
        _backgroudView.userInteractionEnabled = YES;
        _backgroudView.hidden = YES;
        UITapGestureRecognizer *tapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushBottomView)];
        [_backgroudView addGestureRecognizer:tapp];
    }
    return _backgroudView;
}
- (UIHomeworkBottomView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIHomeworkBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 135) style:UITableViewStylePlain];
        _bottomView.homeworkBottomDelegate = self;
    }
    return _bottomView;
}
- (ClockView *)clockView{
    if (_clockView == nil) {
        _clockView = [[ClockView alloc] init];
    }
    return _clockView;
}
@end
