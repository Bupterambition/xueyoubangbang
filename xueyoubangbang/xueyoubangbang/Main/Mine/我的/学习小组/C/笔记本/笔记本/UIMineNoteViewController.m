//
//  UIMineNoteViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineNoteViewController.h"
#import "NSDate+Format.h"
#import "UIHomeworkBottomView.h"
#import "UFOFeedImageViewController.h"
#import "UIHomeworkCheckDetailCell.h"
#import "MBProgressHUD+MJ.h"
#import "Note.h"
#import "StudentGroupViewModel.h"
#import "UIMineNoteDetailCell.h"
#import "UIMineAddNoteViewController.h"
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
    ONELINEPIC = 155,
    TWOLINEPIC = 275
};

@interface UIMineNoteViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIHomeworkCheckDetailDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *table;

@end

@implementation UIMineNoteViewController{
    NSArray *cellTitles;
    NSMutableArray *homeworkData;
    NSString *homeworkTitle;
    NSInteger currentPageIndex;
    NSIndexPath *currentDelete;
}
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initIvar];
//    [self initNav];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    [UIHomeworkNetClient cancelRequest];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNote];
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
    self.navigationItem.title = @"笔记本";
    [self.view addSubview:self.table];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissTextView)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
- (void)initNav{
    UIBarButtonItem *right_check = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"add_grey") style:UIBarButtonItemStylePlain target:self action:@selector(addNote)];
    self.navigationItem.rightBarButtonItem = right_check;
}
- (void)initIvar{
    cellTitles = @[@"作业题目",@"提交时间",@"作业小组",@"知识点"];
    homeworkData = [NSMutableArray array];
}
- (void)initTable{
    self.table.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT-64);
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger picNum = [(Note*)(homeworkData[indexPath.section]) getPicArray].count;
    if (picNum == 0){
        return NOPICANDAUDIO;
    }
    else if (picNum >3){
        return TWOLINEPIC;
    }
    else{
        return ONELINEPIC;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [homeworkData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIMineNoteDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIMineNoteDetailCell"];
    cell.checkDetailDelegate = self;
    cell.currentIndex = indexPath;
    [cell loadItemData:homeworkData[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self disMissTextView];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        weak(weakself);
        [MBProgressHUD showMessage:nil toView:[UIApplication sharedApplication].keyWindow];
        Note *date = homeworkData[currentDelete.section];
        [StudentGroupViewModel deletenote:@{@"userid":UserID,@"noteid":date.item_id} withCallBack:^(BOOL success) {
            if (success) {
                [homeworkData removeObjectAtIndex:currentDelete.section];
                [weakself.table reloadData];
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow];
            }
            else{
                [MBProgressHUD showError:@"删除失败,请稍后再试"];
            }
        }];
    }
}

#pragma mark - UIHomeworkCheckDetailDelegate
- (void)didTouchHomeworkPic:(NSInteger)index withIndex:(NSIndexPath *)indexPath{
    UFOFeedImageViewController *vc = [[UFOFeedImageViewController alloc]initWithCheckPicArray:[(Note*)(homeworkData[indexPath.section]) getPicArray] andCurrentDisplayIndex:index];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)didTouchDeleteNote:(NSIndexPath *)indexPath{
    currentDelete = indexPath;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"⚠️确定要删除该条笔记" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}
#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]) {
        return NO;
    }
    return YES;
}
#pragma mark - event respond
- (void)disMissTextView{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (void)loadMoreNote{
    weak(weakself);
    [StudentGroupViewModel getNotelistswithparameters:[self getNewPara:currentPageIndex+1] withCallBack:^(NSArray *homeWorkDetail) {
        if (homeWorkDetail.count) {
            [homeworkData addObjectsFromArray:homeWorkDetail];
            [weakself.table reloadData];
            currentPageIndex ++;
        }
        [weakself.table.footer endRefreshing];
    }];
}
- (void)loadNote{
    weak(weakself);
    currentPageIndex = 1;
    [StudentGroupViewModel getNotelistswithparameters:[self getNewPara:currentPageIndex] withCallBack:^(NSArray *homeWorkDetail) {
        [homeworkData removeAllObjects];
        [homeworkData addObjectsFromArray:homeWorkDetail];
        [weakself.table reloadData];
        [weakself.table.header endRefreshing];
    }];
}
- (void)addNote{
    UIMineAddNoteViewController *vc = [[UIMineAddNoteViewController alloc] initWithNibName:@"UIMineAddNoteViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - private Method
- (NSDictionary *)getNewPara:(NSInteger)pageIndex{
    return @{@"userid":[GlobalVar instance].user.userid,@"pageIndex":[NSNumber numberWithInteger:pageIndex],@"pageSize":kPageSize};
    
}
#pragma getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE(UITableViewStylePlain);
        _table.delegate = self;
        _table.dataSource = self;
        _table.showsVerticalScrollIndicator = NO;
        [_table registerNib:[UINib nibWithNibName:@"UIMineNoteDetailCell" bundle:nil] forCellReuseIdentifier:@"UIMineNoteDetailCell"];
        [_table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNote)];
        [_table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreNote)];
    }
    return _table;
}
@end
