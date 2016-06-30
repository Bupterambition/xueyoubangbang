//
//  UIHomeworkKnowledgeAddViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/9.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkKnowledgeAddViewController.h"
#import "UIHomeworkSubjectCollectionViewCell.h"
#import "UIHomeworkKnowledgeCell.h"
#import "UIHomeworkDisplayKnowledgeCell.h"
#import "UIHomeworkViewModel.h"
#import "MSubject.h"
#import "KxMenu.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
typedef NS_ENUM(NSInteger, CollectionType){
    KNOWLEDGEPOINTS = 10001,
    SUBJECT = 10002,
    DISPLAYKNOWLEDGE = 10003
};

@interface UIHomeworkKnowledgeAddViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIHomeworkDisplayCellDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *gradeButton;
@property (weak, nonatomic) IBOutlet UIButton *subjectButton;
@property (weak, nonatomic) IBOutlet UICollectionView *knowledgeCollection;

@property (weak, nonatomic) IBOutlet UIView *bottomKnowledgeView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *displayCollection;

@end

@implementation UIHomeworkKnowledgeAddViewController{
    NSArray *subjects;
    CGRect originFrame;
    NSMutableArray *knowledgePoints;
    NSMutableArray *filterPoints;
    UIBarButtonItem *searchItem;
    UIBarButtonItem *displaySearchItem;
    UISearchBar *search;
    NSString *selectedSubject;
    NSString *selectedGrade;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initIvar];
    [self initSignal];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initKnowledgeView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    originFrame = self.bottomKnowledgeView.frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method
- (void)initView{
    UITapGestureRecognizer * tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rswipe:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    self.topView.backgroundColor = STYLE_COLOR;
    self.title = @"添加知识点";
    [self initSearBar];
}
- (void)initSearBar{
    searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarPresent)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 44)];
    search.placeholder = @"点击搜索知识点";
    search.delegate = nil;
    displaySearchItem = [[UIBarButtonItem alloc] initWithCustomView:search];
    UISwipeGestureRecognizer *rswip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rswipe:)];
    rswip.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *lswip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(lswipe:)];
    lswip.direction = UISwipeGestureRecognizerDirectionLeft;
    [search addGestureRecognizer:rswip];
    [search addGestureRecognizer:lswip];
}

- (void)initIvar{
    selectedSubject = @"1";
    selectedGrade = @"2";
    knowledgePoints = [NSMutableArray array];
    filterPoints = [NSMutableArray array];
    subjects = [[CommonMethod subjectDictionary] allValues];
    [self getKnowPoints];
}

- (void)initKnowledgeView{
    [self.knowledgeCollection registerNib:[UINib nibWithNibName:@"UIHomeworkKnowledgeCell" bundle:nil] forCellWithReuseIdentifier:@"UIHomeworkKnowledgeCell"];
    [self.displayCollection registerNib:[UINib nibWithNibName:@"UIHomeworkDisplayKnowledgeCell" bundle:nil] forCellWithReuseIdentifier:@"UIHomeworkDisplayKnowledgeCell"];
}

#pragma mark - UISearchBarDelegate
- (void)initSignal{
    RACSignal *searchSignal = [self rac_signalForSelector:@selector(searchBar:textDidChange:) fromProtocol:@protocol(UISearchBarDelegate)];
    [[searchSignal throttle:0.3] subscribeNext:^(id x) {
        if ([CommonMethod isBlankString:x[1]]) {
            [filterPoints removeAllObjects];
            [filterPoints addObjectsFromArray:knowledgePoints];
            [self.knowledgeCollection reloadData];
        }
        else{
            NSPredicate *resultPredicate = [NSPredicate
                                            predicateWithFormat:@"SELF.knowledgepointname contains[cd] %@",
                                            x[1]];
            [filterPoints removeAllObjects];
            [filterPoints addObjectsFromArray:[knowledgePoints filteredArrayUsingPredicate:resultPredicate]];
            [self.knowledgeCollection reloadData];
        }
    }];
    
    [[self rac_signalForSelector:@selector(searchBarSearchButtonClicked:) fromProtocol:@protocol(UISearchBarDelegate)] subscribeNext:^(id x) {
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"SELF.knowledgepointname contains[cd] %@",
                                        [(UISearchBar*)x[0] text]];
        [filterPoints removeAllObjects];
        [filterPoints addObjectsFromArray:[knowledgePoints filteredArrayUsingPredicate:resultPredicate]];
        [self.knowledgeCollection reloadData];
        [x[0] resignFirstResponder];
        search.placeholder = @"向左滑动显示所有知识点";
    }];
}
#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}


#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == KNOWLEDGEPOINTS){
        return filterPoints.count;
    }
    else if (collectionView.tag == DISPLAYKNOWLEDGE){
        return _displayKnowledgePoints.count;
    }
    else
        return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == KNOWLEDGEPOINTS){
        UIHomeworkKnowledgeCell *cell = (UIHomeworkKnowledgeCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"UIHomeworkKnowledgeCell" forIndexPath:indexPath];
        [cell loadKnowledge:filterPoints[indexPath.row]] ;
        return cell;
    }
    else{
        UIHomeworkDisplayKnowledgeCell *cell = (UIHomeworkDisplayKnowledgeCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"UIHomeworkDisplayKnowledgeCell" forIndexPath:indexPath];
        cell.index = indexPath;
        cell.knowledgeCellDelagate = self;
        [cell loadKnowledge:_displayKnowledgePoints[indexPath.row]];
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (collectionView.tag == KNOWLEDGEPOINTS){
        if (![_displayKnowledgePoints containsObject:filterPoints[indexPath.row]]) {
            [_displayKnowledgePoints addObject:filterPoints[indexPath.row]];
            [self.displayCollection reloadData];
        }
    }
}

#pragma mark - UIHomeworkDisplayCellDelegate
- (void)didTouchDeleteKnowledge:(NSIndexPath*)indexPath{
    [_displayKnowledgePoints removeObjectAtIndex:indexPath.row];
    [self.displayCollection reloadSections:[NSIndexSet indexSetWithIndex:0]];
}
#
#pragma mark - event respond
- (void)getKnowPoints{
    [UIHomeworkViewModel getKnowledgepointsListWithParams:@{@"subjectid":selectedSubject,@"grade":selectedGrade} withCallBack:^(NSArray *knowledge) {
        [knowledgePoints removeAllObjects];
        [knowledgePoints addObjectsFromArray:knowledge];
        [filterPoints removeAllObjects];
        [filterPoints addObjectsFromArray:knowledgePoints];
        [self.knowledgeCollection reloadData];
    }];
}
- (void)searchBarPresent{
    self.navigationItem.title = @"";
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationItem setRightBarButtonItem:displaySearchItem animated:YES];
    [search becomeFirstResponder];
}
- (void)rswipe:(UISwipeGestureRecognizer*)sender{
    self.navigationItem.title = @"添加知识点";
    search.placeholder = @"点击搜索知识点";
    [self.navigationItem setRightBarButtonItem:searchItem animated:YES];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [search resignFirstResponder];
}
- (void)lswipe:(UISwipeGestureRecognizer*)sender{
    [filterPoints removeAllObjects];
    [filterPoints addObjectsFromArray:knowledgePoints];
    [self.knowledgeCollection reloadData];
    search.placeholder = @"向右滑动退出搜索";
    [search resignFirstResponder];
}


- (NSString*)transGrade:(NSString*)grade{
    if ([grade hasPrefix:@"初"]) {
        return @"2";
    }
    else{
        return @"3";
    }
}

/**
 *  顶部按钮，选择班级，弹出GradeView
 *
 *  @param sender 班级button
 */
- (IBAction)didTouchGradeSeletor:(UIButton*)sender {
    [self popGrade];
}
- (void)popGrade{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"初中"
                     image:nil
                    target:self
                    action:@selector(selectGrade:)],
      
      [KxMenuItem menuItem:@"高中"
                     image:nil
                    target:self
                    action:@selector(selectGrade:)]
      ];
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(75, 22, 57, 22)
                 menuItems:menuItems];
    [KxMenu setTintColor:STYLE_COLOR];
}
/**
 *  选择年级
 *
 *  @param sender
 */
- (void)selectGrade:(KxMenuItem *)sender {
    [self.gradeButton setTitle:sender.title forState:UIControlStateNormal];
    selectedGrade = [self transGrade:sender.title];
    [self getKnowPoints];
}

/**
 *  顶部按钮，选择学科，弹出subjectView
 *
 *  @param sender 学科按钮
 */
- (IBAction)didTouchSubject:(UIButton *)sender {
    [self popSubjects];
}
- (void)popSubjects{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"语文"
                     image:nil
                    target:self
                    action:@selector(selectSubjec:)],
      
      [KxMenuItem menuItem:@"数学"
                     image:nil
                    target:self
                    action:@selector(selectSubjec:)],
      [KxMenuItem menuItem:@"英语"
                     image:nil
                    target:self
                    action:@selector(selectSubjec:)],
      
      [KxMenuItem menuItem:@"物理"
                     image:nil
                    target:self
                    action:@selector(selectSubjec:)],
      [KxMenuItem menuItem:@"化学"
                     image:nil
                    target:self
                    action:@selector(selectSubjec:)],
      
      [KxMenuItem menuItem:@"生物"
                     image:nil
                    target:self
                    action:@selector(selectSubjec:)],
      [KxMenuItem menuItem:@"政治"
                     image:nil
                    target:self
                    action:@selector(selectSubjec:)],
      
      [KxMenuItem menuItem:@"历史"
                     image:nil
                    target:self
                    action:@selector(selectSubjec:)],
      [KxMenuItem menuItem:@"地理"
                     image:nil
                    target:self
                    action:@selector(selectSubjec:)]
      ];
    CGRect frame = self.subjectButton.frame;
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(frame.origin.x, frame.origin.y+5, frame.size.width, frame.size.height)
                 menuItems:menuItems];
    [KxMenu setTintColor:STYLE_COLOR];
}
- (void)selectSubjec:(KxMenuItem *)sender{
    NSDictionary* subjectsDic =  @{@"语文":@"1",
                                @"数学":@"2",
                                @"英语":@"3",
                                @"物理":@"4",
                                @"化学":@"5",
                                @"生物":@"6",
                                @"政治":@"7",
                                @"历史":@"8",
                                @"地理":@"9",
                                };
    [self.subjectButton setTitle:sender.title forState:UIControlStateNormal];
//    self.baseHomeWork.subjectid = ;
    selectedSubject = subjectsDic[sender.title];
    [self getKnowPoints];
}
#pragma mark - private Method

@end
