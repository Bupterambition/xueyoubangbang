//
//  UIRankingViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/12.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIRankingViewController.h"
#import "MJRefresh.h"
#define tableOriginY 40
@interface UIRankingViewController ()
{
    UISegmentedControl *segment;
    
    UIView *today;
    UIView *total;
    UIView *fastest;
    
    UITableView *todayTableView;
    
    UIScrollView *pageView;
    
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;

}
@end

@implementation UIRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hidesBottomBarWhenPushed = YES;
    [self initPageView];
    [self initSegment];
}

- (void)initSegment
{
    segment = [ [ UISegmentedControl alloc ] initWithItems: nil ];
    
    [ segment insertSegmentWithTitle:
     @"今日排名" atIndex: 0 animated: NO ];
    [ segment insertSegmentWithTitle:
     @"总分" atIndex: 1 animated: NO ];
    [segment insertSegmentWithTitle:@"完成最快" atIndex:2 animated:NO];
    CGFloat width = 300;
    segment.frame = CGRectMake(self.view.frame.size.width / 2 - width / 2, kNavigateBarHight, width, tableOriginY);
    
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(segementChange) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    
}

- (void)initPageView
{
    CGFloat btnWidth = 300;
    CGFloat btnHeight = 40;
    pageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    CGFloat w = pageView.bounds.size.width;
    CGFloat h = pageView.bounds.size.height - 100;
    int const kCount = 3;
    
    
    
    pageView.contentSize = CGSizeMake(kCount * w, 0);
    pageView.showsHorizontalScrollIndicator = NO;
    pageView.pagingEnabled = YES;
    pageView.delegate = self;
    pageView.bounces = NO;
    
    CGFloat listViewHeight = tableOriginY;
    today = [self createListView];
    today.frame = CGRectMake(0, listViewHeight, w, h);
    today.backgroundColor = [UIColor redColor];
    [pageView addSubview:today];
    
    total = [self createListView];
    total.frame = CGRectMake(w, listViewHeight, w, h);
    total.backgroundColor = [UIColor greenColor];
    [pageView addSubview:total];
    
    fastest = [self createListView];
    fastest.frame = CGRectMake(w * 2, listViewHeight, w, h);
    fastest.backgroundColor = [UIColor blueColor];
    [pageView addSubview:fastest];
    
    [self.view addSubview:pageView];
    
}

- (UIView *)createListView
{
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor redColor];
    todayTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - kNavigateBarHight - kTabBarHeight - tableOriginY) style:UITableViewStylePlain];
    todayTableView.delegate = self;
    todayTableView.dataSource = self;
    todayTableView.backgroundView = nil;
    todayTableView.backgroundColor = [UIColor clearColor];
    todayTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    todayTableView.separatorColor = RGB(190, 196, 210);
    if (IOS_VERSION_7_OR_ABOVE) {
        todayTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    __weak typeof(self) weakSelf = self;
    
    // 添加传统的下拉刷新
    [todayTableView addLegendHeader];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    todayTableView.legendHeader.refreshingBlock = ^{
        NSLog(@"loadNew");
        [weakSelf loadNewData:todayTableView];
    };
    
    // 马上进入刷新状态
//    [todayTableView.legendHeader beginRefreshing];
    
    // 添加传统的上拉刷新
    [todayTableView addLegendFooter];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    todayTableView.legendFooter.refreshingBlock = ^{
        NSLog(@"loadMore");
        [weakSelf loadMoreData:todayTableView];
    };

    [container addSubview:todayTableView];
    
    return container;
    
}

- (void)loadData
{
    
}

- (void)loadNewData:(UITableView *)tableView
{
    __weak typeof(tableView) weakTableView = tableView;

        // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [todayTableView reloadData];
    
            // 拿到当前的上拉刷新控件，结束刷新状态
            [todayTableView.header endRefreshing];
        });
}

- (void)loadMoreData:(UITableView *)tableView
{
        // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [todayTableView reloadData];
    
            // 拿到当前的上拉刷新控件，结束刷新状态
            [todayTableView.footer endRefreshing];
//        });
}


#pragma SegementEvent
- (void)segementChange
{
    NSInteger selectIndex = segment.selectedSegmentIndex;
    CGFloat w = pageView.frame.size.width;
    [pageView scrollRectToVisible:CGRectMake(w * selectIndex,pageView.frame.origin.y , w, pageView.frame.size.height) animated:YES];
    NSLog(@"segementChange %d",(int)selectIndex);
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if(page != segment.selectedSegmentIndex){
        // 设置页码
        segment.selectedSegmentIndex = page;
    }
    NSLog(@"%d", page);
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //        cell.backgroundView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"bg_setup_nor"] stretchableImageWithLeftCapWidth:6 topCapHeight:6]];
        //        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"bg_setup_pre"] stretchableImageWithLeftCapWidth:6 topCapHeight:6]];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    //    cell.textLabel.textColor = RGB(100, 100, 100);

    cell.textLabel.text = @"textLable";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    cell.detailTextLabel.textColor = RGB(100, 100, 100);
    cell.detailTextLabel.text = @"detailText";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
