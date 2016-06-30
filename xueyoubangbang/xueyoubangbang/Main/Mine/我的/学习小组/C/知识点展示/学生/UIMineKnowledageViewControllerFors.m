//
//  UIMineKnowledageViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/4.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineKnowledageViewControllerFors.h"
#import "UUChart.h"
#import "KnowledgeCell.h"
#import "StudentGroupViewModel.h"
#import "NSDate+Format.h"
#import "UIHomeworkViewModel.h"
#import "StudentGroup.h"
#import "MissTableViewCell.h"
#import "NSArray+CoreModel.h"

@interface UIMineKnowledageViewControllerFors ()<UUChartDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
/**
 *  用于显示作业中的知识点
 */
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *knowledgeView;
@property (strong, nonatomic) UUChart *barchatView;
@property (strong, nonatomic) UUChart *linechatView;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *monthSelector;
@property (weak, nonatomic) IBOutlet UIScrollView *subjectSelector;
@property (weak, nonatomic) IBOutlet UITableView *missTable;
@end
typedef NS_ENUM(NSInteger, CollectionType){
    KNOWLEDGEPOINTS = 10001,
    ACCURACYSTATISTICS = 10002
};
@implementation UIMineKnowledageViewControllerFors{
    NSArray *knowledges;
    UIButton *titleButton;
    CGRect originTableFrame;
    CGRect currentTableFrame;
    CGRect originSubjectFrame;
    CGRect currentSubjectFrame;
    NSString *currentSubject;
//    NSString *current
    NSString *currentMonth;
    NSString *currentYear;
    
    NSArray *knowledgepointsName;
    NSArray *occurrenceNumber;
    NSArray *currentMonthDay;
    NSArray *accuracyStatistics;
    NSArray *validdays ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initIvar];
    [self getAllSubject];
    [self addTitleButton];
    [self initChatView];
    [self initCollection];
    [self initTable];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    originTableFrame = _monthSelector.frame;
    originTableFrame.origin = CGPointMake(0, 40);
    CGRect frame = originTableFrame;
    frame.size = CGSizeMake(frame.size.width, 0);
    frame.origin = CGPointZero;
    currentTableFrame = frame;
    _monthSelector.frame = frame;
    
    originSubjectFrame = _subjectSelector.frame;
    originSubjectFrame.origin = CGPointMake(0, 0);
    CGRect frames = originSubjectFrame;
    frames.size = CGSizeMake(frame.size.width, 0);
    currentSubjectFrame = frames;
    _subjectSelector.frame = frames;
    
    _missTable.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - init Method
- (void)addTitleButton{
    titleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 35)];
    titleButton.backgroundColor = [UIColor clearColor];
    [titleButton setTitle:[NSString stringWithFormat:@"%ld月",[currentMonth integerValue]] forState:UIControlStateNormal];
    [titleButton setImage:IMAGE(@"login_classinformation_pulldown") forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(popMonthselector:) forControlEvents:UIControlEventTouchUpInside];
    [titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 72, 0, 0)];
    [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    self.navigationItem.titleView = titleButton;
    
    NSArray *month = @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
    [month enumerateObjectsUsingBlock:^(NSString* selectedmonth, NSUInteger idx, BOOL *stop) {
        UIButton *monthButton = ({
            UIButton *everyButton = [[UIButton alloc]initWithFrame:CGRectMake(60*idx, 8, 55, 20)];
            everyButton.tag = 1+idx;
            [everyButton addTarget:self action:@selector(selectMonth:) forControlEvents:UIControlEventTouchUpInside];
            [everyButton setTitle:selectedmonth forState:UIControlStateNormal];
            everyButton.backgroundColor = [UIColor clearColor];
            [everyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            everyButton;
        });
        [_monthSelector addSubview:monthButton];
    }];
    [_monthSelector setContentSize:CGSizeMake(60 * 12, 39)];
}
- (void)initCollection{
    _knowledgeView.dataSource = self;
    _knowledgeView.delegate = self;
    [_knowledgeView registerNib:[UINib nibWithNibName:@"KnowledgeCell" bundle:nil] forCellWithReuseIdentifier:@"KnowledgeCell"];
    [self.view addSubview:_knowledgeView];
}

- (void)initTable{
    _missTable.sectionHeaderHeight = 1;
    _missTable.sectionFooterHeight = 1;
    _missTable.showsVerticalScrollIndicator = NO;
    _missTable.rowHeight = 38;
    _missTable.separatorColor = [UIColor clearColor];
    [_missTable registerNib:[UINib nibWithNibName:@"MissTableViewCell" bundle:nil] forCellReuseIdentifier:@"MissTableViewCell"];
}
- (void)initChatView{
    _barchatView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT - 164-90) withSource:self withStyle:UUChartBarStyle];
    [_barchatView showInView:self.view];
    
    _linechatView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 75, SCREEN_WIDTH, SCREEN_HEIGHT - 164-90) withSource:self withStyle:UUChartLineStyle];
    _linechatView.hidden = YES;
    [_linechatView showInView:self.view];
    
    [self.view bringSubviewToFront:self.unitLabel];
    [self.view bringSubviewToFront:self.displayLabel];
}
- (void)initIvar{
    currentYear = [[NSDate date] format:@"YYYY"];
    currentMonth = [[NSDate date] format:@"MM"];
    if ([currentMonth integerValue] < 8) {
        currentYear = @"2016";
    }
    else{
        currentYear = @"2015";
    }
    knowledgepointsName = [NSArray array];
    occurrenceNumber = [NSArray array];
    accuracyStatistics = [NSArray array];
    validdays = [NSArray array];
    currentMonthDay = [NSArray array];
}
#pragma mark - private Method
- (NSDictionary*)getparamForKnowledgePoints{
    return @{@"groupid":self.groupid == nil?@"":self.groupid,
             @"month":NSIntTOString([currentMonth integerValue]),
             @"year":currentYear
             };
}
- (NSDictionary*)getparamForAccuracystatistics{
    return @{@"groupid":self.groupid == nil?@"":self.groupid,
             @"month":NSIntTOString([currentMonth integerValue]),
             @"year":currentYear,
             @"studentid":UserID
             };
}
#pragma mark - event respond
- (void)getAllSubject{
    weak(weakself);
    [UIHomeworkViewModel getstudentGroupListWithParams:@{@"studentid":[GlobalVar instance].user.userid} withCallBack:^(NSArray *Students) {
        [Students enumerateObjectsUsingBlock:^(StudentGroup *obj, NSUInteger idx, BOOL *stop) {
            if (idx == 0) {
                self.groupid = NSIntTOString(obj.groupid) ;
            }
            UIButton *monthButton = ({
                UIButton *everyButton = [[UIButton alloc]initWithFrame:CGRectMake(60*idx, 8, 55, 20)];
                everyButton.titleLabel.adjustsFontSizeToFitWidth = YES;
                everyButton.tag = 1+idx;
                [everyButton addTarget:self action:@selector(selectSubject:) forControlEvents:UIControlEventTouchUpInside];
                [everyButton setTitle:[obj groupname] forState:UIControlStateNormal];
                everyButton.tag = [[obj getGroupID] integerValue];
                everyButton.backgroundColor = [UIColor clearColor];
                [everyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                everyButton;
            });
            [_subjectSelector addSubview:monthButton];
            [weakself getKnowledageOccur];
        }];
        [_subjectSelector setContentSize:CGSizeMake(60 * Students.count <SCREEN_WIDTH?SCREEN_WIDTH:60 * Students.count, 39)];
    }];
}
/**
 *  获得出现的知识点列表以及次数
 */
- (void)getKnowledageOccur{
    weak(weakself);
    [MBProgressHUD showMessage:@"加载中" toView:[UIApplication sharedApplication].keyWindow];
    [StudentGroupViewModel getKnowledgePointStatisticswithparameters:[self getparamForKnowledgePoints] withCallBack:^(NSArray *memberlist) {
        knowledgepointsName = memberlist[1] == nil?[NSArray array]:memberlist[1];
        occurrenceNumber = memberlist[2] == nil?[NSArray array]:memberlist[2];
        [weakself.barchatView strokeChart];
        weakself.knowledgeView.tag = KNOWLEDGEPOINTS;
        weakself.knowledgeView.hidden = NO;
        weakself.missTable.hidden = YES;
        [weakself.knowledgeView reloadData];
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }];
}
- (void)getAccuracystatistics{
    weak(weakself);
    [MBProgressHUD showMessage:@"加载中" toView:[UIApplication sharedApplication].keyWindow];
    [StudentGroupViewModel getAccuracystatisticswithparameters:[self getparamForAccuracystatistics] withCallBack:^(NSArray *dayaccstatistics) {
        currentMonthDay = [(NSArray*)dayaccstatistics[0] toDaysWithMonth:currentMonth];
        accuracyStatistics = (NSArray*)dayaccstatistics[0] ;
        validdays = dayaccstatistics[1];
        [weakself reBuildLine];
        weakself.knowledgeView.hidden = YES;
        weakself.missTable.hidden = NO;
        [weakself.missTable reloadData];
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow];
    }];
}
- (void)reBuildLine{
    [_linechatView removeFromSuperview];
    _linechatView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 75, SCREEN_WIDTH, SCREEN_HEIGHT - 164-85) withSource:self withStyle:UUChartLineStyle];
    _linechatView.hidden = NO;
    [_linechatView showInView:self.view];
}
- (void)selectMonth:(UIButton*)sender{
    [titleButton setTitle:sender.currentTitle forState:UIControlStateNormal];
    currentMonth = NSIntTOString(sender.tag);
    if ([currentMonth integerValue] < 8) {
        currentYear = @"2016";
    }
    else{
        currentYear = @"2015";
    }
    if (self.knowledgeView.hidden) {
        [self getAccuracystatistics];
    }
    else{
        [self getKnowledageOccur];
    }
    [self popMonthselector:titleButton];
}
- (void)selectSubject:(UIButton*)sender{
    self.groupid = NSIntTOString(sender.tag);
    if (self.knowledgeView.hidden) {
        [self getAccuracystatistics];
    }
    else{
        [self getKnowledageOccur];
    }
    [self popMonthselector:titleButton];
}
- (void)popMonthselector:(UIButton*)sender{
    [UIView animateWithDuration:0.3 animations:^{
        if (!sender.selected) {
            _monthSelector.frame = originTableFrame;
            _subjectSelector.frame = originSubjectFrame;
        }
        else{
            _monthSelector.frame = currentTableFrame;
            _subjectSelector.frame = currentSubjectFrame;
        }
        
    } completion:^(BOOL finished) {
        if (!sender.selected) {
            _monthSelector.frame = originTableFrame;
            _subjectSelector.frame = originSubjectFrame;
        }
        else {
            _monthSelector.frame = currentTableFrame;
            _subjectSelector.frame = currentSubjectFrame;
        }
        sender.selected = !sender.selected;
    }];
}
- (IBAction)displayViewChange:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _unitLabel.text = @"个/月";
        _linechatView.hidden = YES;
        _barchatView.hidden = NO;
        [_barchatView strokeChart];
        [self getKnowledageOccur];
    }
    else {
        [self getAccuracystatistics];
        _unitLabel.text = @"错误率/月";
        _linechatView.hidden = NO;
        _barchatView.hidden = YES;
    }
}
#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MissTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissTableViewCell"];
    [cell loadData:accuracyStatistics withValidDays:validdays withIndex:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return knowledgepointsName.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KnowledgeCell *cell = (KnowledgeCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"KnowledgeCell" forIndexPath:indexPath];
    cell.knowledgeLabel.text = knowledgepointsName[indexPath.row];
    if (collectionView.tag == KNOWLEDGEPOINTS) {
        cell.percentLabel.text = [NSString stringWithFormat:@"%@次",occurrenceNumber[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - UUChartDataSource-required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    if (chart.chartStyle == UUChartLineStyle) {
        return currentMonthDay;
    }
    else{
        return knowledgepointsName;
    }
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    if (chart.chartStyle == UUChartBarStyle) {
        return occurrenceNumber !=nil?@[occurrenceNumber]:nil;
    }
    else{
        return accuracyStatistics !=nil?@[accuracyStatistics]:nil;
    }
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUTest,UURed,UUBrown];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    return CGRangeMake(100, 0);
}

#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart
{
    return CGRangeMake(25, 75);
}

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return YES;
}

#pragma mark - setter and getter

@end
