//
//  UIMineNewStudentsJoinVC.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/1.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//
#define ACCESS 10001
#import <objc/runtime.h>
#import <objc/message.h>
#import "MBProgressHUD+MJ.h"
#import "UIMineNewStudentsJoinVC.h"
#import "StudentGroupViewModel.h"

@interface NewStudentCells : UITableViewCell
- (void)loadData:(Member*)data withTarget:(UIViewController*)target andSelecter:(SEL)method withIndex:(NSUInteger)index;
@end

@implementation NewStudentCells{
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

@interface UIMineNewStudentsJoinVC ()
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation UIMineNewStudentsJoinVC{
    
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
    self.datasource = [NSMutableArray array];
    [self.tableView registerClass:NSClassFromString(@"NewStudentCells") forCellReuseIdentifier:@"NewStudentCells"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = VIEW_BACKGROUND_COLOR;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (void)loadData{
    weak(weakself);
    [StudentGroupViewModel GetGroupMemberListwithparameters:@{@"groupid":_groupinfo == nil?_groupID:@(_groupinfo.groupid),@"accept":@0} withCallBack:^(NSArray *memberlist) {
        if (memberlist != nil) {
            [self.tableView.legendHeader endRefreshing];
            [weakself.datasource removeAllObjects];
            [weakself.datasource addObjectsFromArray:memberlist];
            [self.tableView reloadData];
        }
        else{
            [self.tableView.legendHeader endRefreshing];
        }
    }];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewStudentCells *cell = [tableView dequeueReusableCellWithIdentifier:@"NewStudentCells"];
    [cell loadData:self.datasource[indexPath.row] withTarget:self andSelecter:@selector(doAccessStudent:) withIndex:indexPath.row];
    return cell;
}

#pragma mark - event Respond
- (void)doAccessStudent:(NSUInteger)currentIndex{
    Member *acceptMember = self.datasource[currentIndex];
    weak(weakself);
    [StudentGroupViewModel operateGroupMember:@{@"studentid":acceptMember.userid,@"accept":@0,@"groupid":_groupinfo == nil?_groupID:@(_groupinfo.groupid),@"operate":@1} withCallBack:^(BOOL success) {
        @try {
            if (success) {
                [MBProgressHUD showSuccess:@"已加入班级"];
                [weakself.datasource removeObjectAtIndex:currentIndex];
                [weakself.tableView reloadData];
            }
            else{
                [MBProgressHUD showError:@"已加入班级"];
                [weakself.datasource removeObjectAtIndex:currentIndex];
                [weakself.tableView reloadData];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            
        }
        
    }];
}



@end
