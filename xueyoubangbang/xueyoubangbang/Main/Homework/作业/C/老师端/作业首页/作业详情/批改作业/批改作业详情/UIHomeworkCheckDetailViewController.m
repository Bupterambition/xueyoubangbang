//
//  UIHomeworkCheckDetailViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkCheckDetailViewController.h"
#import "NoneSelectorTableViewCell.h"
#import "SelectorTableViewCell.h"
#import "UIHomeworkViewModel.h"
#import "CheckHomeWorkStudent.h"
#import "HomeworkSubmitInfo.h"
#import "SingleStudentHomeworkAnswer.h"
#import "DWBubbleMenuButton.h"
#import "UFOFeedImageViewController.h"
#import "UIHomeworkViewModel.h"
#import "MBProgressHUD+MJ.h"
#import "UIHomeworkCommentViewController.h"
#import "SingleStudentHomeworkInfo.h"
#import "UIEditImageViewController.h"
#define CurrentScreenHeight  SCREEN_HEIGHT - kNavigateBarHight
@interface UIHomeworkCheckDetailViewController ()<UITableViewDataSource,UITableViewDelegate,NoneSelectorTableViewCellDelegate,UIEditImageDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UILabel *placeLabel;
/**
 *  保存非选择题，用于更新老师批改后的图片
 */
@property (nonatomic, strong) NSMutableArray *checkAnswer;
@end

@implementation UIHomeworkCheckDetailViewController{
    /**  第一批改时答案 */
    NSArray *answers;
    NSString *homeworkid;
    NSString *userid;
    BOOL ifChecked;
    DWBubbleMenuButton *downButton ;
    NSInteger rate;
    /**  复查答案 */
    NSArray *answersForChecked;
    NSString *userName;
}
- (instancetype)initWithHomework:(CheckHomeWorkStudent*)homeworkDetail{
    self = [super init];
    if (self) {
        homeworkid = homeworkDetail.homeworkid;
        userid = homeworkDetail.userid;
        ifChecked = [homeworkDetail.homeworkchecked isEqualToString:@"1"]?YES:NO;
        userName = homeworkDetail.username;
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
    self.table.frame = CGRectMake(5, 5, SCREEN_WIDTH-10, SCREEN_HEIGHT - kNavigateBarHight - 57);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - init Method
- (void)initBaseView{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"批改作业";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(finishCheck)];
    [self.view addSubview:self.table];
}
- (void)initBottomView{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, CurrentScreenHeight - 50, SCREEN_WIDTH - 20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, CurrentScreenHeight-38, 65, 21)];
    self.placeLabel.font = [UIFont systemFontOfSize:17];
    self.placeLabel.text = @"总评:A";
    
    UIImageView *tapView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    tapView.contentMode = UIViewContentModeScaleAspectFit;
    tapView.image = IMAGE(@"subject_pulldown");
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 88, CurrentScreenHeight - 46, 72, 30)];
    commentLabel.text = @"写评语";
    commentLabel.font = [UIFont systemFontOfSize:15];
    commentLabel.userInteractionEnabled = YES;
    UIImageView *commentImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-33, CurrentScreenHeight-41, 17, 24)];
    commentImg.contentMode = UIViewContentModeScaleAspectFit;
    commentImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didtouchEdit)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didtouchEdit)];
    [commentImg addGestureRecognizer:tap1];
    [commentLabel addGestureRecognizer:tap];
    commentImg.image = IMAGE(@"edit");
    
    downButton =[[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(68, CurrentScreenHeight-41, tapView.frame.size.width, tapView.frame.size.height)
                                       expansionDirection:DirectionUp];
    downButton.homeButtonView = tapView;
    downButton.buttonSpacing = 5.0f;
    [downButton addButtons:[self createButtonArray]];
    
    [self.view addSubview:line];
    [self.view addSubview:self.placeLabel];
    [self.view addSubview:downButton];
    [self.view addSubview:commentLabel];
    [self.view addSubview:commentImg];
}
- (void)initIvar{
    answers = [NSArray array];
    answersForChecked = [NSArray array];
    rate = 1;
}
- (void)loadHomeworkItem{
    weak(weakself);
    if (ifChecked) {
        [UIHomeworkViewModel getStudentReviewWithParams:@{@"homeworkid":homeworkid,@"userid":userid} withCallBack:^(NSArray *Students) {
            if (Students != nil) {
                answersForChecked = Students;
                weakself.evaluate = [(SingleStudentHomeworkInfo*)answersForChecked[0] evaluate];
                [weakself.table reloadData];
            }
        }];
    }
    else{
        [UIHomeworkViewModel getStudentanswerWithParams:@{@"homeworkid":homeworkid,@"userid":userid} withCallBack:^(NSArray *Students) {
            answers = Students;
            [weakself.table reloadData];
        }];
    }
}
#pragma mark - UITableViewDataSource and UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static SingleStudentHomeworkAnswer *tempData ;
    if (indexPath.row == 0) {
        return 45;
    }
    if (ifChecked) {
        tempData = answersForChecked[1][indexPath.row -1];
    }
    else{
        tempData = answers[1][indexPath.row -1];
    }
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
    if (ifChecked) {
        return answersForChecked.count == 0?0:[answersForChecked[1] count] +1;
    }
    return answers.count == 0 ?0:[answers[1] count] +1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (ifChecked) {
        if (indexPath.row == 0) {
            HomeworkSubmitInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkSubmitInfo"];
            [answersForChecked[0] setUsername:userName];
            [cell loadInfo:answersForChecked[0]];
            rate = [[(SingleStudentHomeworkInfo*)answersForChecked[0] rate] integerValue];
            self.placeLabel.text = [NSString stringWithFormat:@"总评:%@",@{@"1":@"A",@"2":@"B",@"3":@"C",@"4":@"D"}[rate==0?@"1":NSIntTOString(rate)]];
            return cell;
        }
        else{
            SingleStudentHomeworkAnswer *tempData = answersForChecked[1][indexPath.row -1];
            if (tempData.type == 0) {//非选择题
                NoneSelectorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoneSelectorTableViewCell"];
                cell.index = indexPath;
                cell.noneseletorDelegate = self;
                [cell loadAnswerDataForChecked:[CommonMethod isBlankString:tempData.update_answer]? tempData.answer:tempData.update_answer withAnswerscore:[tempData.answerscore integerValue] withPreAnswer:tempData];
                return cell;
            }
            else{//选择题
                SelectorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectorTableViewCell"];
                [cell loadSelectorAnswer:tempData.selectanswer];
                return cell;
            }
        }
    }
    else{
        if (indexPath.row == 0) {
            HomeworkSubmitInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkSubmitInfo"];
            [cell loadInfo:answers[0]];
            return cell;
        }
        else{
            SingleStudentHomeworkAnswer *tempData = answers[1][indexPath.row -1];
            if (tempData.type == 0) {//非选择题
                NoneSelectorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoneSelectorTableViewCell"];
                cell.index = indexPath;
                cell.noneseletorDelegate = self;
                [cell loadAnswerDataForChecked:[CommonMethod isBlankString:tempData.update_answer]? tempData.answer:tempData.update_answer withAnswerscore:99 withPreAnswer:tempData];
                return cell;
            }
            else{//选择题
                SelectorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectorTableViewCell"];
                [cell loadSelectorAnswer:tempData.selectanswer];
                return cell;
            }
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
    if (ifChecked) {
        UIEditImageViewController *vc = [[UIEditImageViewController alloc]initWithCheckPicArray:[((SingleStudentHomeworkAnswer*)[answersForChecked[1] objectAtIndex:currentIndex.row-1]).answer componentsSeparatedByString:@","] andCurrentDisplayIndex:index withAnswer:[answersForChecked[1] objectAtIndex:currentIndex.row-1]];
        vc.editImageDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else{
        UIEditImageViewController *vc = [[UIEditImageViewController alloc]initWithCheckPicArray:[((SingleStudentHomeworkAnswer*)[answers[1] objectAtIndex:currentIndex.row-1]).answer componentsSeparatedByString:@","] andCurrentDisplayIndex:index withAnswer:[answers[1] objectAtIndex:currentIndex.row-1]];
        vc.editImageDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
        
    }
    
}
- (void)didGiveTheScore:(NSInteger)index withIndex:(NSIndexPath *)currentIndex{
    if (ifChecked) {
        [(SingleStudentHomeworkAnswer*)[answersForChecked[1] objectAtIndex:currentIndex.row-1] setNoSelectoranswer:@(index)];
    }
    else{
        [(SingleStudentHomeworkAnswer*)[answers[1] objectAtIndex:currentIndex.row-1] setNoSelectoranswer:@(index)];
    }
    
}
#pragma mark - UIEditImageDelegate
- (void)didChangeImage{
    [self.table reloadData];
}
#pragma mark - event response
- (void)finishCheck{
    [UIHomeworkViewModel checkHomeworkWithParams:[self getPara] withCallBack:^(BOOL success) {
        if (success) {
            [MBProgressHUD showSuccess:@"已提交批改结果"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [MBProgressHUD showSuccess:@"改作业已重新批改"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didTouchScore:(UIButton*)sender{
    rate = sender.tag;
    self.placeLabel.text = [NSString stringWithFormat:@"总评:%@",sender.currentTitle];
}
- (void)didtouchEdit{
    UIHomeworkCommentViewController *vc = [[UIHomeworkCommentViewController alloc] initWithNibName:@"UIHomeworkCommentViewController" bundle:nil];
    vc.evaluate = self.evaluate;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - private method
- (NSMutableArray*)createButtonArray{
    NSMutableArray *btns = [NSMutableArray array];
    [@[@"A",@"B",@"C",@"D"] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = CREATE_BUTTON(0, 0, 30, 30, obj, nil, @selector(didTouchScore:));
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 15;
        btn.tag = idx+1;
        btn.layer.borderColor = [UIColor blackColor].CGColor;
        btn.backgroundColor = STYLE_COLOR;
        btn.titleLabel.textColor = [UIColor blackColor];
        [btns addObject:btn];
    }];
    return btns;
}
- (NSDictionary *)getPara{
    
    if (ifChecked) {
        NSMutableDictionary *otherPara = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":userid,@"homeworkid":homeworkid,@"itemnum":@([answersForChecked[1] count])}];
        for (NSInteger i = 1; i <= [answersForChecked[1] count]; i++){
            SingleStudentHomeworkAnswer *tempData = [answersForChecked[1] objectAtIndex:i-1];
            
            NSString *keyItemTitle = [NSString stringWithFormat:@"item_%ld_id",i];
            NSString *valueItemTitle = tempData.homeworkitemid?tempData.homeworkitemid:@"";
            [otherPara setObject:valueItemTitle forKey:keyItemTitle];
            
            NSString *keyItemType = [NSString stringWithFormat:@"item_%ld_type",i];
            NSInteger valueItemType = tempData.type;
            [otherPara setObject:@(valueItemType) forKey:keyItemType];
            
            if (valueItemType == 1) {
                NSString *keyItemAnswer = [NSString stringWithFormat:@"item_%ld_answer",i];
                NSString *valueItemAnswer = tempData.selectanswer;
                [otherPara setObject:valueItemAnswer forKey:keyItemAnswer];
            }
            else{
                NSString *keyItemAnswer = [NSString stringWithFormat:@"item_%ld_answer",i];
                [otherPara setObject:tempData.noSelectoranswer forKey:keyItemAnswer];
            }
        }
        [otherPara setObject:@(rate) forKey:@"rate"];
        [otherPara setObject:self.evaluate == nil?@"":self.evaluate forKey:@"evaluate"];
        return otherPara;
    }
    else{
        NSMutableDictionary *otherPara = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":userid,@"homeworkid":homeworkid,@"itemnum":@([answers[1] count])}];
        for (NSInteger i = 1; i <= [answers[1] count]; i++){
            SingleStudentHomeworkAnswer *tempData = [answers[1] objectAtIndex:i-1];
            
            NSString *keyItemTitle = [NSString stringWithFormat:@"item_%ld_id",i];
            NSString *valueItemTitle = tempData.homeworkitemid?tempData.homeworkitemid:@"";
            [otherPara setObject:valueItemTitle forKey:keyItemTitle];
            
            NSString *keyItemType = [NSString stringWithFormat:@"item_%ld_type",i];
            NSInteger valueItemType = tempData.type;
            [otherPara setObject:@(valueItemType) forKey:keyItemType];
            
            if (valueItemType == 1) {
                NSString *keyItemAnswer = [NSString stringWithFormat:@"item_%ld_answer",i];
                NSString *valueItemAnswer = tempData.selectanswer;
                [otherPara setObject:valueItemAnswer forKey:keyItemAnswer];
            }
            else{
                NSString *keyItemAnswer = [NSString stringWithFormat:@"item_%ld_answer",i];
                [otherPara setObject:tempData.noSelectoranswer forKey:keyItemAnswer];
            }
        }
        [otherPara setObject:@(rate) forKey:@"rate"];
        [otherPara setObject:self.evaluate == nil?@"":self.evaluate forKey:@"evaluate"];
        return otherPara;
    }
}
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
- (NSMutableArray*)checkAnswer{
    if (_checkAnswer == nil) {
        _checkAnswer = [NSMutableArray array];
    }
    return _checkAnswer;
}
@end
