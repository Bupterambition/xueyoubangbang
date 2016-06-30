//
//  UIHomeworkReviewCheck.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkReviewCheck.h"
#import "UIHomeworkCheckDetailViewController.h"
#import "NoneSelectorTableViewCell.h"
#import "SelectorTableViewCell.h"
#import "UIHomeworkViewModel.h"
#import "CheckHomeWorkStudent.h"
#import "HomeworkSubmitInfo.h"
#import "SingleStudentHomeworkAnswer.h"
#import "UFOFeedImageViewController.h"
#import "UIHomeworkViewModel.h"
#import "MBProgressHUD+MJ.h"
#import "UIHomeworkCommentViewController.h"
#import "SingleStudentHomeworkInfo.h"

#define CurrentScreenHeight  SCREEN_HEIGHT - kNavigateBarHight
@interface UIHomeworkReviewCheck ()<UITableViewDataSource,UITableViewDelegate,NoneSelectorTableViewCellDelegate>
@property (nonatomic, strong) UITableView *table;


@end

@implementation UIHomeworkReviewCheck{
    NSArray *answers;
    NSString *homeworkid;
    UILabel *placeLabel;
    NSInteger rate;
    NSString *groupName;
    UIView *bottomView;
    UILabel *commentLabel;
}
- (instancetype)initWithHomework:(NSArray*)homeworkDetail{
    self = [super init];
    if (self) {
        homeworkid = homeworkDetail[0];
        groupName = homeworkDetail[1];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseView];
    [self initBottomView];
    [self initIvar];
    [self loadHomeworkItem];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews{
    self.table.frame = CGRectMake(5, 5, SCREEN_WIDTH-10, SCREEN_HEIGHT - kNavigateBarHight);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - init Method
- (void)initBaseView{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"答题卡";
    
}
- (void)initBottomView{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 3, SCREEN_WIDTH - 30, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 57, 21)];
    placeLabel.font = [UIFont systemFontOfSize:19];
    placeLabel.textColor = [UIColor redColor];
    placeLabel.text = @"评语:";
    
    commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 48, SCREEN_WIDTH - 40, 40)];
    commentLabel.text = @"写评语";
    commentLabel.numberOfLines = 0;
    commentLabel.font = [UIFont systemFontOfSize:16];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -10, 120)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:line];
    [bottomView addSubview:placeLabel];
    [bottomView addSubview:commentLabel];
    self.table.tableFooterView = bottomView;
    [self.view addSubview:self.table];
}
- (void)initIvar{
    answers = [NSArray array];
}
- (void)loadHomeworkItem{
    weak(weakself);
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [UIHomeworkViewModel getStudentReviewWithParams:@{@"homeworkid":homeworkid,@"userid":[GlobalVar instance].user.userid} withCallBack:^(NSArray *Students) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (Students != nil) {
            answers = Students;
            commentLabel.text = [(SingleStudentHomeworkInfo*)answers[0] evaluate];
            [weakself.table reloadData];
        }
        
    }];
}
#pragma mark - UITableViewDataSource and UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static SingleStudentHomeworkAnswer *tempData ;
    if (indexPath.row == 0) {
        return 45;
    }
    tempData = answers[1][indexPath.row -1];
    if (tempData.type == 0) {//非选择题
        return 216;
    }
    else{//选择题
        CGFloat num = ([tempData.selectanswer componentsSeparatedByString:@","].count +6)/7.0f;
        NSInteger tt = ceil(num);
        return 80+ 74*(tt-1);
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return answers.count == 0 ?0:[answers[1] count] +1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HomeworkSubmitInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkSubmitInfo"];
        [cell loadInfo:groupName withScore:[(SingleStudentHomeworkInfo*)answers[0] rate]];
        return cell;
    }
    else{
        SingleStudentHomeworkAnswer *tempData = answers[1][indexPath.row -1];
        if (tempData.type == 0) {//非选择题
            NoneSelectorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoneSelectorTableViewCell"];
            cell.index = indexPath;
            cell.noneseletorDelegate = self;
            [cell loadAnswerDataForReview:tempData.answer withAnswerscore:[tempData.answerscore integerValue]];
            return cell;
        }
        else{//选择题
            SelectorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectorTableViewCell"];
            [cell loadSelectorAnswer:tempData.selectanswer];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
#pragma mark - NoneSelectorTableViewCellDelegate
- (void)didToDetail:(NSInteger)index withIndex:(NSIndexPath *)currentIndex{
    UFOFeedImageViewController *vc = [[UFOFeedImageViewController alloc]initWithCheckPicArray:[((SingleStudentHomeworkAnswer*)[answers[1] objectAtIndex:currentIndex.row-1]).answer componentsSeparatedByString:@","] andCurrentDisplayIndex:index];
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - event response

#pragma mark - private method


#pragma getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE(UITableViewStylePlain);
        _table.delegate = self;
        _table.dataSource = self;
        
        [_table registerNib:[UINib nibWithNibName:@"NoneSelectorTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoneSelectorTableViewCell"];
        [_table registerNib:[UINib nibWithNibName:@"SelectorTableViewCell" bundle:nil] forCellReuseIdentifier:@"SelectorTableViewCell"];
        [_table registerNib:[UINib nibWithNibName:@"HomeworkSubmitInfo" bundle:nil] forCellReuseIdentifier:@"HomeworkSubmitInfo"];
    }
    return _table;
}

@end
