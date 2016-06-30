//
//  UIInterActDetailViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/29.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIInterActDetailViewController.h"
#import "UIHomeworkViewModel.h"
#import "MQuestion.h"
#import "AnswerObject.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "InterActCell.h"
#import "UIHomeworkViewModel.h"
#import "InterActDetailCell.h"
#import "UIInterActAskViewController.h"
#import "UFOFeedImageViewController.h"
#import "StudentGroupViewModel.h"

@interface UIInterActDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIInterActDelegate>
@property (nonatomic, strong) UITableView *table;

@end

@implementation UIInterActDetailViewController{
    NSMutableArray *datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"互动圈";
    [self.view addSubview:self.table];
    [self initIvar];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我来回答" style:UIBarButtonItemStylePlain target:self action:@selector(myAnswer)];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
#pragma mark - init Method

- (void)loadData{
    weak(weakself);
    [UIHomeworkViewModel getQuestionAnswerListWithParams:@{@"id":_questionid,
                                                           @"userid":_userid
                                                     }
                                      withCallBack:^(NSArray *questions){
                                          [datasource removeAllObjects];
                                          [datasource addObjectsFromArray:questions];
                                          [weakself.table reloadData];
                                      }];
}
- (void)initIvar{
    datasource = [NSMutableArray array];
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
    if (section == 0) {
        return 1;
    }
    else{
        return [datasource[1] count] + 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MQuestion *data = datasource[0];
        CGFloat collectionHeight;
        if ([data getPicArray].count == 0) {
            if ([CommonMethod isBlankString:data.audio]) {
                collectionHeight = 0;
            }
            else{
                collectionHeight = 0;
            }
        }
        else if ([data getPicArray].count <= 3){
            if ([CommonMethod isBlankString:data.audio]) {
                collectionHeight = 80;
            }
            else{
                collectionHeight = 80;
            }
        }
        else{
            collectionHeight = 150;
        }
        return collectionHeight + [tableView fd_heightForCellWithIdentifier:@"InterActCell" cacheByIndexPath:indexPath configuration:^(InterActCell *cell) {
            [cell loadData:datasource[indexPath.row] withIndex:indexPath];
        }];
    }
    else{
        if (indexPath.row == 0) {
            return 45;
        }
        else
            return [tableView fd_heightForCellWithIdentifier:@"InterActDetailCell" cacheByIndexPath:indexPath configuration:^(InterActDetailCell *cell) {
                [cell loadData:datasource[1][indexPath.row-1]];
            }];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        InterActCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InterActCell"];
        cell.currentIndex = indexPath;
        cell.actDelegate = self;
        [cell loadData:datasource[indexPath.section] withIndex:indexPath];
        return cell;
    }
    else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.textLabel.text = @"回答";
            return cell;
        }
        else{
            InterActDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InterActDetailCell"];
            cell.currentIndex = indexPath;
            [cell loadData:datasource[1][indexPath.row-1]];
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
- (void)myAnswer{
    UIInterActAskViewController *vc = [[UIInterActAskViewController alloc] initWithNibName:@"UIInterActAskViewController" bundle:nil];
    vc.ifFromMyAnswer = YES;
    vc.questionid = _questionid;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE(UITableViewStylePlain);
        _table.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT - 64);
        _table.showsVerticalScrollIndicator = NO;
        _table.delegate = self;
        _table.dataSource = self;
        _table.estimatedSectionFooterHeight = 20;
        //        _table.estimatedRowHeight = 130;
        [_table registerNib:[UINib nibWithNibName:@"InterActCell" bundle:nil] forCellReuseIdentifier:@"InterActCell"];
        [_table registerNib:[UINib nibWithNibName:@"InterActDetailCell" bundle:nil] forCellReuseIdentifier:@"InterActDetailCell"];
    }
    return _table;
}
@end
