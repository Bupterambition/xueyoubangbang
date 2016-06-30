//
//  UIMessageFriendAcceptViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMessageFriendAcceptViewController.h"
#define ACCESS 10001
#import <objc/runtime.h>
#import <objc/message.h>
#import "MBProgressHUD+MJ.h"
#import "MessageViewModel.h"
#import "Member.h"
@interface NewStudentCell : UITableViewCell
- (void)loadData:(Member*)data withTarget:(UIViewController*)target andSelecter:(SEL)method withIndex:(NSUInteger)index;
@end

@implementation NewStudentCell{
    NSUInteger currentIndex;
    UIViewController *currentVC;
    SEL currentselector;
}
#pragma init Method
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 8, 60, 30) ];
    [button setTitle:@"接受" forState:UIControlStateNormal];
    button.backgroundColor = RGB(0,198,58);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:button];
    [button addTarget:self action:@selector(doAccess) forControlEvents:UIControlEventTouchUpInside];
    button.tag = ACCESS;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.imageView setFrame:CGRectMake(10, 8,self.frame.size.height - 2 * 8, self.frame.size.height - 2 * 8)];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = (self.frame.size.height - 2 * 8)/2;
    
    [self.textLabel setFrame:CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + 10, (self.frame.size.height - self.textLabel.frame.size.height - self.detailTextLabel.frame.size.height ) / 2, self.textLabel.frame.size.width, self.textLabel.frame.size.height)];
    
    [self.detailTextLabel setFrame:CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + 10, self.textLabel.frame.origin.y + self.textLabel.frame.size.height , self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height)];
}
- (void)loadData:(Member*)data withTarget:(UIViewController*)target andSelecter:(SEL)method withIndex:(NSUInteger)index{
    currentIndex = index;
    currentVC = target;
    currentselector = method;
    self.textLabel.text = data.username;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg(data.header_photo)] placeholderImage:DEFAULT_HEADER];
    
}
#pragma mark - event Respond
- (void)doAccess{
    ((void(*)(id,SEL, unsigned long))objc_msgSend)(currentVC, currentselector, currentIndex);
}

@end

@interface UIMessageFriendAcceptViewController ()

@end

@implementation UIMessageFriendAcceptViewController{
    NSMutableArray *datasource;
    NSInteger currentIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method
- (void)initTableView{
    [self.tableView registerClass:NSClassFromString(@"NewStudentCell") forCellReuseIdentifier:@"NewStudentCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = VIEW_BACKGROUND_COLOR;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadData{
    currentIndex = 1;
    [MessageViewModel getFriendListWithParams:@{@"userid":UserID,@"pageIndex":@(currentIndex),@"pageSize":kPageSize} withCallBack:^(NSArray *friendlist) {
        if (friendlist != nil) {
            datasource = [NSMutableArray arrayWithArray:friendlist];
            [self.tableView reloadData];
        }
        [self.tableView.legendHeader endRefreshing];
    }];
}
- (void)loadMoreData{
    [MessageViewModel getFriendListWithParams:@{@"userid":UserID,@"pageIndex":@(currentIndex +1),@"pageSize":kPageSize} withCallBack:^(NSArray *friendlist) {
        if (friendlist != nil) {
            currentIndex++;
            datasource = [NSMutableArray arrayWithArray:friendlist];
            [self.tableView reloadData];
        }
        [self.tableView.legendHeader endRefreshing];
    }];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewStudentCell"];
    [cell loadData:datasource[indexPath.row] withTarget:self andSelecter:@selector(doAccessStudent:) withIndex:indexPath.row];
    return cell;
}

#pragma mark - event Respond
- (void)doAccessStudent:(NSUInteger)CurrentIndex{
    Member *acceptMember = datasource[CurrentIndex];
    weak(weakself);
    [MessageViewModel acceptFriendWithParams:[CommonMethod getParaWithOther:@{@"id":acceptMember.userid}] withCallBack:^(BOOL success) {
        if (success) {
            [MBProgressHUD showSuccess:@"已接受申请"];
            [datasource removeObjectAtIndex:CurrentIndex];
            [weakself.tableView reloadData];
        }
    }];
}

@end
