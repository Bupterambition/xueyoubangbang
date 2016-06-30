//
//  UIInterActViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/20.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIInterActMyQuestionViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "InterActCell.h"
#import "MQuestion.h"
#import "UIHomeworkViewModel.h"
#import "UFOFeedImageViewController.h"
#import "UIInterActDetailViewController.h"
#import "StudentGroupViewModel.h"

@interface UIInterActMyQuestionViewController ()<UITableViewDataSource,UITableViewDelegate,UIInterActDelegate>
@property (nonatomic, strong) UITableView *table;
@end

@implementation UIInterActMyQuestionViewController{
    NSMutableArray *datasource;
    NSInteger currentIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"互动圈";
    [self.view addSubview:self.table];
    [self initIvar];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
#pragma mark - init Method
- (void)loadData{
    weak(weakself);
    [UIHomeworkViewModel getQuestionListWithParams:@{@"pageSize":@20,
                                                     @"pageIndex":@1,
                                                     @"type":@1,
                                                     @"userid":UserID
} withCallBack:^(NSArray *questions) {
    [weakself.table.header endRefreshing];
    [datasource removeAllObjects];
    [datasource addObjectsFromArray:questions];
    [weakself.table reloadData];
    currentIndex = 1;
    }];
}
- (void)initIvar{
    datasource = [NSMutableArray array];
    currentIndex = 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return datasource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MQuestion *data = datasource[indexPath.section];
    CGFloat collectionHeight;
    if ([data getPicArray].count == 0) {
        if ([CommonMethod isBlankString:data.audio]) {
            collectionHeight = 0;
        }
        else{
            collectionHeight = 80;
        }
    }
    else if ([data getPicArray].count < 3){
        if ([CommonMethod isBlankString:data.audio]) {
            collectionHeight = 80;
        }
        else{
            collectionHeight = 80;
        }
    }
    else if ([data getPicArray].count == 3){
        if ([CommonMethod isBlankString:data.audio]) {
            collectionHeight = 80;
        }
        else{
            collectionHeight = 150;
        }
    }
    else{
        collectionHeight = 150;
    }
    return collectionHeight + [tableView fd_heightForCellWithIdentifier:@"InterActCell" cacheByIndexPath:indexPath configuration:^(InterActCell *cell) {
        [cell loadData:datasource[indexPath.row] withIndex:indexPath];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InterActCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InterActCell"];
    cell.currentIndex = indexPath;
    cell.actDelegate = self;
    [cell loadData:datasource[indexPath.section] withIndex:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MQuestion *data = datasource[indexPath.section];
    UIInterActDetailViewController *vc = [[UIInterActDetailViewController alloc] init];
    vc.userid = data.user_id;
    vc.questionid = data.question_id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UIInterActDelegate
- (void)didTouchHomeworkPic:(NSInteger)index withIndex:(NSIndexPath *)indexPath{
    MQuestion *data = datasource[indexPath.section];
    UFOFeedImageViewController *vc = [[UFOFeedImageViewController alloc] initWithCheckPicArray:[data getPicArray] andCurrentDisplayIndex:index];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
- (void)didTouchAddNote:(NSIndexPath *)indexPath{
    [StudentGroupViewModel addNoteWithParams:[self testGetPara:indexPath] withFileDataArr:nil withCallBack:^(BOOL success) {
        if (success) {
            [MBProgressHUD showSuccess:@"已添加到笔记本"];
        }
    }];
}
- (NSDictionary *)testGetPara:(NSIndexPath*)indexPath{
    MQuestion *data = datasource[indexPath.section];
    NSMutableDictionary *otherPara = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":[GlobalVar instance].user.userid,@"subjectid":data.subject_id?data.subject_id:@0,@"item_info":data.desc?data.desc:@"",@"item_imgscnt":@([data getPicArray].count)}];
    if ([data getPicArray].count) {
        for (NSInteger j = 1; j<=[data getPicArray].count; j++) {
            NSString *name = [NSString stringWithFormat:@"item_img_%ld",j];
            [otherPara setObject:UrlResStringForImg([data getPicArray][j-1]) forKey:name];
        }
    }
    
    if(![CommonMethod isBlankString:data.audio]){
        [otherPara setObject:UrlResStringForImg(data.audio) forKey:@"item_audio"];
    }
    return otherPara;
}
#pragma mark - event response
- (void)loadMoreData{
    weak(weakself);
    [UIHomeworkViewModel getQuestionListWithParams:@{@"pageSize":@20,
                                                     @"pageIndex":@(currentIndex +1),
                                                     @"type":@1,
                                                     @"userid":UserID
                                                     } withCallBack:^(NSArray *questions) {
                                                         if (questions) {
                                                             [datasource addObjectsFromArray:questions];
                                                             [weakself.table reloadData];
                                                             currentIndex++;
                                                         }
                                                         [weakself.table.footer endRefreshing];
                                                     }];
}
#pragma getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE(UITableViewStylePlain);
        _table.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT - 64);
        _table.showsVerticalScrollIndicator = NO;
        _table.delegate = self;
        _table.dataSource = self;
        [_table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        [_table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_table registerNib:[UINib nibWithNibName:@"InterActCell" bundle:nil] forCellReuseIdentifier:@"InterActCell"];
    }
    return _table;
}
@end
