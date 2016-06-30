//
//  UIQuestionListViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//  
// iOS test

#import "UIQuestionListViewController.h"
#import "UIQuestionTableViewCell.h"
#import "UIQuestionDetailViewController.h"
#import "MQuestion.h"
#import "UIQuestionAskViewController.h"
#import "UIQuestionTableViewCell2.h"
#import "AFNetClient.h"
@interface UIQuestionListViewController()<popDelegate>
{
    UITableView *table;
   
    NSMutableArray *othersQuestionArr;
    NSMutableArray *myQuestionArr;
    
    UIButton *btnTopLeft;
    UIButton *btnTopRight;
    UIView *selected0;
    UIView *selected1;
    NSInteger currentPageIndex;
    BOOL hasLoadData;
}
@property (nonatomic) NSInteger questionType; //1我的 2同学的
@end

@implementation UIQuestionListViewController

#define LEFT_LABLE 10001
#define CELL_H 100.0f
#define CELL_NUMBER 4
#pragma mark - UITableViewDataSource

- (id)init
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
        [self initial];
    }
    return self;
}

- (void)initial
{
    _questionType = 2;
    currentPageIndex = 0;
    othersQuestionArr = [NSMutableArray array];
    myQuestionArr = [NSMutableArray array];
    hasLoadData = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!hasLoadData){
        hasLoadData = YES;
        // 马上进入刷新状态
        [table.legendHeader beginRefreshing];
    }
}

- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"问题列表";
    
    if([rolesUser isEqualToString:roleStudent])
    {
        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        top.backgroundColor = [UIColor whiteColor];
        
        btnTopLeft = [[UIButton alloc] init];
        btnTopLeft.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2, 40);
        [btnTopLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnTopLeft setTitle:@"我的提问" forState:UIControlStateNormal];
        [btnTopLeft addTarget:self action:@selector(doBtnLeftClick) forControlEvents:UIControlEventTouchUpInside];
        [top addSubview:btnTopLeft];
        
        btnTopRight = [[UIButton alloc] init];
        btnTopRight.frame = CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 40);
        [btnTopRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnTopRight setTitle:@"同学提问" forState:UIControlStateNormal];
        [btnTopRight addTarget:self action:@selector(doBtnRightClick) forControlEvents:UIControlEventTouchUpInside];
        [top addSubview:btnTopRight];
        if([GlobalVar instance].homeInfo.questioncnt > 0)
        {
            UIFont *font = btnTopRight.titleLabel.font;
            CGSize size = [CommonMethod sizeWithString:@"同学提问" font:font maxSize:CGSizeMake(btnTopRight.frame.size.width,btnTopRight.frame.size.height)];
            
            CGPoint offset = CGPointMake((btnTopRight.frame.size.width - size.width) / 2 + size.width, (btnTopRight.frame.size.height - size.height) / 2);
            [btnTopRight addRedPointWithOffset:offset];
        }
        else
        {
            [btnTopRight removeRedPoint];
        }
        
        UIView *seperate = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 5, 1, 40 - 2 * 5)];
        seperate.backgroundColor = VIEW_BACKGROUND_COLOR;
        [top addSubview:seperate];
        
        selected0 = [[UIView alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH / 2 - 2 * 10, 2)];
        selected0.backgroundColor = STYLE_COLOR;
        selected0.hidden = YES;
        [top addSubview:selected0];
        
        selected1 = [[UIView alloc] initWithFrame:CGRectMake(10 + SCREEN_WIDTH / 2, 40, SCREEN_WIDTH / 2 - 2 * 10, 2)];
        selected1.backgroundColor = STYLE_COLOR;
        selected1.hidden = YES;
        [top addSubview:selected1];
        
        self.questionType = _questionType;
        
        table = CREATE_TABLE(UITableViewStyleGrouped);
        table.delegate = self;
        table.dataSource = self;
        table.frame = CGRectMake(0, top.frame.size.height + top.frame.origin.y, SCREEN_WIDTH, self.view.bounds.size.height - kNavigateBarHight - top.frame.size.height - top.frame.origin.y );
        [self.view addSubview:table];
        
        [self.view addSubview:top];
    }
    else if([rolesUser isEqualToString:roleTeacher])
    {
        self.questionType = _questionType;
        
        table = CREATE_TABLE(UITableViewStyleGrouped);
        table.delegate = self;
        table.dataSource = self;
        table.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height - kNavigateBarHight);
        [self.view addSubview:table];
    }
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) weakSelf = self;
    // 添加传统的下拉刷新
    [table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(reload)];
//    [table addLegendHeader];
//    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//    table.legendHeader.refreshingBlock = ^{
//        NSLog(@"loadNew");
//        [weakSelf reload];
//        
//        //        [weakSelf loadNewData:todayTableView];
//    };

    // 添加传统的上拉刷新
    [table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
//    [table addLegendFooter];
//    
//    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//    //    [table.legendFooter endRefreshing];
//    table.legendFooter.refreshingBlock = ^{
//        NSLog(@"loadMore %ld",(long)currentPageIndex);
//        //        [weakSelf loadMoreData:todayTableView];
//        [weakSelf loadMore];
//    };
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(doAdd)];

    self.navigationItem.rightBarButtonItem = rightBar;
}

//去掉UItableview headerview黏性(sticky)
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"contentOffset y = %f",scrollView.contentOffset.y);
//    CGFloat sectionFooterHeight = SECTION_FOOTER_HEIGHT;
//    if (scrollView.contentOffset.y>=-sectionFooterHeight&&scrollView.contentOffset.y<=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y<=-sectionFooterHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(sectionFooterHeight, 0, 0, 0);
//    }
//}

- (NSDictionary *)getPara:(NSInteger )pageIndex
{
    NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key,@"pageIndex":[NSNumber numberWithInteger:pageIndex],@"pageSize":kPageSize,@"type":[NSNumber numberWithInteger :_questionType]};
    return para;
}

- (void)reload
{
    NSLog(@"kUrlQuestionList reload");
    [self hideLegendFooter];
    currentPageIndex = 1;
    NSDictionary *para = [self getPara:currentPageIndex];
    [AFNetClient GlobalGet:kUrlQuestionList parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [[self dataQuestion] removeAllObjects];
        NSLog(@"kUrlQuestionList = %@",dataDict);
        [table.legendHeader endRefreshing];
        
        if(isUrlSuccess(dataDict))
        {
            NSArray *list = [dataDict objectForKey:@"list"];
            
            for (int i = 0 ; i < list.count; i++) {
                MQuestion *m = [MQuestion objectWithDictionary:[list objectAtIndex:i]];
                [[self dataQuestion] addObject:m];
            }
            if(list.count > 0){
                [table reloadData];
                
            }
            else
            {
                [table.legendFooter noticeNoMoreData];
            }
        }
        else
        {
            [table.legendFooter noticeNoMoreData];
        }
        [self showLegendFooter];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [table.legendHeader endRefreshing];
        [self showLegendFooter];
    }];
}

- (void)loadMore
{
    NSDictionary *para = [self getPara:currentPageIndex + 1];
    [AFNetClient GlobalGet:kUrlQuestionList parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [table.legendFooter endRefreshing];
        NSLog(@"kUrlQuestionList = %@",dataDict);
        
        if(isUrlSuccess(dataDict))
        {
            NSArray *list = [dataDict objectForKey:@"list"];
            for (int i = 0; i < list.count; i++) {
                MQuestion *qu = [MQuestion objectWithDictionary:[list objectAtIndex:i]];
                [[self dataQuestion] addObject:qu];
            }
            if(list.count > 0){
                currentPageIndex ++;
                [table reloadData];
            }
            else
            {
                [table.legendFooter noticeNoMoreData];
            }
        }
        else
        {
            [table.legendFooter noticeNoMoreData];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [table.legendFooter endRefreshing];
    }];
    
}

-(void)showLegendFooter
{
    table.legendFooter.hidden = NO;
}

-(void)hideLegendFooter
{
    table.legendFooter.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self dataQuestion].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionPadding;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *CellIdentifier = @"cellIdentifier";
////    UIQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
////    if (nil == cell) {
//      UIQuestionTableViewCell*  cell = [[UIQuestionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
////        NSLog(@"textLable.frame:%@",NSStringFromCGRect(cell.textLabel.frame));
//        
////    }
//    MQuestion *qu = [[self dataQuestion] objectAtIndex:indexPath.section];
//    [cell settingData:qu];
//    return cell;
    
    NSString *CellIdentifier = @"cellIdentifier";
    UIQuestionTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if(nil == cell)
//    {
        cell = [[UIQuestionTableViewCell2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
//    }
    cell.question = [[self dataQuestion] objectAtIndex:indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MQuestion *qu = [[self dataQuestion] objectAtIndex:indexPath.section];
    
//    UIQuestionTableViewCellFrame *frame = [[UIQuestionTableViewCellFrame alloc] initWithQuestion:qu];
//    return frame.cellHeight;
    return [UIQuestionTableViewCell2 cellHeight:qu];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIQuestionDetailViewController *ctrl = [[UIQuestionDetailViewController alloc] init];
    MQuestion *qu = [[self dataQuestion] objectAtIndex:indexPath.section];
    ctrl.question = qu;
    ctrl.questionType = _questionType;
    
    [self.navigationController pushViewController:ctrl animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setQuestionType:(NSInteger)questionType
{
    if(questionType == 2){
        selected1.hidden = NO;
        selected0.hidden = YES;
    }
    else
    {
        selected1.hidden = YES;
        selected0.hidden = NO;
    }
    _questionType = questionType;
}

- (NSMutableArray *)dataQuestion
{
    if(_questionType == 1)
        return myQuestionArr;
    return othersQuestionArr;
}

- (void)doAdd
{
    UIQuestionAskViewController *ctrl = [[UIQuestionAskViewController alloc] init];
//    [self presentViewController:ctrl animated:YES completion:nil];
    ctrl.popDelegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)doBtnLeftClick
{
    self.questionType = 1;
    [table reloadData];
    [table.legendHeader beginRefreshing];
}

- (void)doBtnRightClick
{
    self.questionType = 2;
    [table reloadData];
    [table.legendHeader beginRefreshing];
}

- (void)popFromViewController:(UIViewController*) controller WithUserinfo:(id)userinfo
{
    if([rolesUser isEqualToString:roleStudent])
    {
        if([controller isKindOfClass:[UIQuestionAskViewController class]])
        {
            self.questionType = 1;
            [table.legendHeader beginRefreshing];
        }
    }
}

@end
