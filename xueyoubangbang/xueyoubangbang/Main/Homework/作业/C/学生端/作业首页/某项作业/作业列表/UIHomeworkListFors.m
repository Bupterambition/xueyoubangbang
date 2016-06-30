
//
//  UIHomeworkListFors.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkListFors.h"
#import "StudentHomeworkCell.h"
#import "UIHomeworkViewModel.h"
#import "UIHomeworkDetailFors.h"
#import "NewHomeWork.h"
#import "UIHomeworkReviewCheck.h"
#import "UIMineKnowledageViewController.h"
#import "NSString+Stackoverflow.h"
#import "UIHomeworkDetailHomeworkViewController.h"
@interface UIHomeworkListFors ()<UITableViewDataSource,UITableViewDelegate,StudentHomeworkCellDelegate>
@property (nonatomic, strong) UITableView *table;
@end

@implementation UIHomeworkListFors{
    NSMutableArray *homeworks;
    NSInteger currentPage;
    UIImageView *_bgView;
    CGFloat curBgViewHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table];
    [self initView];
    [self initIvar];
    [self.table.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillLayoutSubviews{
    self.table.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT-64);
}

#pragma mark - init Method
- (void)initView{
    [self createInfoPanelView];
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    if (!self.ifMessage) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"学习记录" style:UIBarButtonItemStylePlain target:self action:@selector(seeStudyRecord)];
    }
}
- (void)initIvar{
    homeworks = [NSMutableArray array];
    currentPage = 1;
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return homeworks.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StudentHomeworkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentHomeworkCell"];
    [cell loadNewHomeWorkData:homeworks[indexPath.section]];
    cell.studentHomeworkCellDelegate = self;
    cell.index = indexPath;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.ifMessage) {
        UIHomeworkDetailHomeworkViewController *vc = [[UIHomeworkDetailHomeworkViewController alloc] init];
        vc.home_work_id = [(NewHomeWork*)homeworks[indexPath.section] homework_id];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        UIHomeworkDetailFors *vc = [[UIHomeworkDetailFors alloc] init];
        vc.home_work_id = [(NewHomeWork*)homeworks[indexPath.section] homework_id];
        if ([(NewHomeWork*)homeworks[indexPath.section] ischecked]  == 1) {
            vc.ifFinish = YES;
        }
        else if ([(NewHomeWork*)homeworks[indexPath.section] dayleft]  <0) {
            vc.ifFinish = YES;
        }
        else{
            if ([(NewHomeWork*)homeworks[indexPath.section] dayleft] == 0){
                NSDate *newDate = [[(NewHomeWork*)homeworks[indexPath.section] finishtime] transTimeWithFormat:@"yyyy-MM-dd HH:mm:ss"];
                if ([newDate timeIntervalSinceNow]<0) {
                    vc.ifFinish = YES;
                }
            }
            else
                vc.ifSubmit = NO;
        }
        if ([[(NewHomeWork*)homeworks[indexPath.section] status] integerValue] == 1) {
            vc.ifSubmit = NO;
        }
        else{
            vc.ifSubmit = NO;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}


#pragma mark - 创建表盘
- (void)createInfoPanelView{
    
    UIImage *image = [UIImage imageNamed:@"clock_handler"];
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 110.f, 150.f, 62.f)];
    bgView.image = [image stretchableImageWithLeftCapWidth:image.size.width/2.0 topCapHeight:image.size.height/2.0];
    bgView.userInteractionEnabled = YES;
    bgView.alpha = 0.f;
    _bgView = bgView;
    [self.view addSubview:bgView];
    
    UIImageView *clockImage = [[UIImageView alloc]initWithFrame:CGRectMake(6.f, 6.f, 50.f, 50.f)];
    clockImage.image = [UIImage imageNamed:@"表盘图标"];
    clockImage.tag = 10010;
    [_bgView addSubview:clockImage];
    
    UIImageView *minImage = [[UIImageView alloc]initWithFrame:CGRectMake(5.f, 5.f, 40.f, 40.f)];
    minImage.image = [UIImage imageNamed:@"分钟"];
    minImage.tag = 10011;
    [clockImage addSubview:minImage];
    
    UIImageView *hourImage = [[UIImageView alloc]initWithFrame:CGRectMake(25.f/2, 25.f/2, 25.f, 25.f)];
    hourImage.image = [UIImage imageNamed:@"时钟"];
    hourImage.tag = 10012;
    [clockImage addSubview:hourImage];
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(66.f, 10.f + i*28.f, 90.f, 15.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = (i == 0) ? [UIColor whiteColor] : [UIColor colorWithRed:192/255.f green:190/255.f blue:191/255.f alpha:1.0];
        titleLabel.font = (i == 0) ? [UIFont boldSystemFontOfSize:15.f] : [UIFont systemFontOfSize:13.f];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.tag = 10020 + i;
        [_bgView addSubview:titleLabel];
    }
}

#pragma mark - 表盘时间控制
- (void)changeTime:(float)hour min:(float)min{
    
    UIImageView *clockImage = (UIImageView *)[_bgView viewWithTag:10010];
    UIImageView *minImage = (UIImageView *)[clockImage viewWithTag:10011];
    UIImageView *hourImage = (UIImageView *)[clockImage viewWithTag:10012];
    
    CGAffineTransform hourTransform = CGAffineTransformMakeRotation((hour + min/60.f) *(M_PI / 6.0f));
    
    CGAffineTransform minTransform = CGAffineTransformMakeRotation(min *(M_PI / 30.0f));
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        hourImage.transform = hourTransform;
        minImage.transform = minTransform;
    } completion:nil];
}
#pragma mark - 滑动回调代理

- (void)infoPanelDidScroll:(UITableView *)messageBaseTableView atPoint:(CGPoint)point {
    
    
    NSIndexPath * indexPath = [messageBaseTableView indexPathForRowAtPoint:point];
    NSString *dataString =[((NewHomeWork *)homeworks[indexPath.section]).finishtime transTimeWithOriginFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"yyyy-MM-dd HH:mm"] ;
    UILabel *timeLabel = (UILabel *)[_bgView viewWithTag:10020];
    UILabel *dateLabel = (UILabel *)[_bgView viewWithTag:10021];
    if (dataString && dataString.length == 16) {
        NSString *dateString = [dataString substringToIndex:10];
        NSString *timeString = [dataString substringFromIndex:11];
        
        CGFloat hour = [[timeString substringToIndex:2] floatValue];
        CGFloat min = [[timeString substringFromIndex:3] floatValue];
        
        if (hour > 12.f) {
            hour = hour - 12.f;
            NSString *tureTime = (hour < 10) ? [timeString stringByReplacingCharactersInRange:NSMakeRange(0,2) withString:[NSString stringWithFormat:@"0%.f",hour]] : [timeString stringByReplacingCharactersInRange:NSMakeRange(0,2) withString:[NSString stringWithFormat:@"%.f",hour]];
            timeLabel.text = [NSString stringWithFormat:@"下午 %@",tureTime];
        }else{
            
            timeLabel.text = [NSString stringWithFormat:@"上午 %@",timeString];
        }
        
        dateLabel.text = dateString;
        [self changeTime:hour min:min];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UITableView *)messageBaseTableView{
    if (homeworks.count == 0) {
        return;
    }
    CGFloat heightScale = 0.f;
    if (messageBaseTableView.contentOffset.y <= 0 || messageBaseTableView.contentOffset.y >= messageBaseTableView.contentSize.height - messageBaseTableView.frame.size.height) {
        
        heightScale = (messageBaseTableView.contentOffset.y > 0) ? 0.99999f : 0.f;
    }else{
        
        heightScale = messageBaseTableView.contentOffset.y/(messageBaseTableView.contentSize.height - messageBaseTableView.frame.size.height);
    }
    
    curBgViewHeight = heightScale * (messageBaseTableView.frame.size.height-49);
    
    CGRect newFrame = _bgView.frame;
    newFrame.origin.y = curBgViewHeight - 62.f*heightScale  ;
    _bgView.frame = newFrame;
    
    _bgView.hidden = (messageBaseTableView.contentSize.height < messageBaseTableView.frame.size.height) ? YES : NO;
    CGFloat indexHeight = heightScale*messageBaseTableView.contentSize.height + (0.5 - heightScale)*62.f;
    
    [self infoPanelDidScroll:messageBaseTableView atPoint:CGPointMake(20.f, indexHeight)];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.2 animations:^{
        
        _bgView.alpha = 1.f;
        CGRect newFrame = _bgView.frame;
        if (newFrame.origin.x == self.view.frame.size.width) {
            
            newFrame.origin.x = self.view.frame.size.width - 150.f;
            _bgView.frame = newFrame;
        }
        
    }completion:^(BOOL finished) {
        
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.2 animations:^{
        
        _bgView.alpha = 0.f;
        CGRect newFrame = _bgView.frame;
        if (newFrame.origin.x != self.view.frame.size.width) {
            
            newFrame.origin.x = self.view.frame.size.width;
            _bgView.frame = newFrame;
        }
        
    }completion:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [UIView animateWithDuration:0.2 animations:^{
            
            _bgView.alpha = 0.f;
            CGRect newFrame = _bgView.frame;
            if (newFrame.origin.x != self.view.frame.size.width) {
                
                newFrame.origin.x = self.view.frame.size.width;
                _bgView.frame = newFrame;
            }
            
        }completion:nil];
    }
}

#pragma mark - StudentHomeworkCellDelegate
- (void)didToReview:(NSInteger)index{
    NewHomeWork *data = homeworks[index];
    UIHomeworkReviewCheck *vc = [[UIHomeworkReviewCheck alloc] initWithHomework:@[data.homework_id,data.title]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -event respond
- (void)seeStudyRecord{
    //新入口
    UIMineKnowledageViewController *vc = [[UIMineKnowledageViewController alloc] initWithNibName:@"UIMineKnowledageViewController" bundle:nil];
    vc.groupid = self.groupid;
    vc.studentid = UserID;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)newLoadHomeWork{
    self.table.legendFooter.hidden = YES;
    currentPage = 1;
    weak(weakself);
    [UIHomeworkViewModel getHomeworkListWithParams:[self getNewPara:currentPage] withCallBack:^(NSArray *homeworkList) {
        [homeworks removeAllObjects];
        [weakself getRankArray:homeworkList];
        [weakself.table reloadData];
        [weakself.table.legendHeader endRefreshing];
        weakself.table.legendFooter.hidden = NO;
    }];
}
- (void)newloadMoreHomeworks{
    weak(weakself);
    [UIHomeworkViewModel getHomeworkListWithParams:[self getNewPara:currentPage+1] withCallBack:^(NSArray *homeworkList) {
        if (homeworkList != nil && homeworkList.count !=0) {
            currentPage ++;
            [weakself getRankArray:homeworkList];
            [weakself.table reloadData];
            [weakself.table.legendFooter endRefreshing];
        }
        [weakself.table.legendFooter endRefreshing];
    }];
}

#pragma mark - private Method
- (void)getRankArray:(NSArray*)data{
    NSPredicate *resultPredicateForCheck = [NSPredicate
                                    predicateWithFormat:@"SELF.ischecked = %ld",
                                    1];
    NSPredicate *resultPredicateForUncheck = [NSPredicate
                                            predicateWithFormat:@"SELF.ischecked = %ld",
                                            0];
    [homeworks addObjectsFromArray:[data filteredArrayUsingPredicate:resultPredicateForUncheck]];
    [homeworks addObjectsFromArray:[data filteredArrayUsingPredicate:resultPredicateForCheck]];
}
- (NSDictionary *)getNewPara:(NSInteger)pageIndex{
    return @{@"userid":UserID,@"groupid":self.groupid,@"pageIndex":[NSNumber numberWithInteger:pageIndex],@"pageSize":kPageSize};
}
#pragma getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE(UITableViewStylePlain);
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerNib:[UINib nibWithNibName:@"StudentHomeworkCell" bundle:nil] forCellReuseIdentifier:@"StudentHomeworkCell"];
        _table.rowHeight = 105;
        _table.sectionFooterHeight = 10;
        // 添加传统的下拉刷新
        [_table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(newLoadHomeWork)];
        // 添加传统的上拉刷新
        [_table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(newloadMoreHomeworks)];
    }
    return _table;
}
@end
