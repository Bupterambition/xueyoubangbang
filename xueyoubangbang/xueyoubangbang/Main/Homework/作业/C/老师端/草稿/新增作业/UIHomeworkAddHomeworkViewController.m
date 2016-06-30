//
//  UIHomeworkAddHomeworkViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkAddHomeworkViewController.h"
#import "UIHomeworkKnowledgeAddViewController.h"
#import "UIHomeworkAddCell.h"
#import "NSDate+Format.h"
#import "UIHomeworkBottomView.h"
#import "UIHomeworkSelectSetting.h"
#import "NewHomeWorkSend.h"
#import "NewHomeworkFileSend.h"
#import "UFOFeedImageViewController.h"
#import "UIHomeworkAddDetailCell.h"
#import "SaveHomeWork.h"
#import "MBProgressHUD+MJ.h"
#import "UIHomeworkAssignMentVC.h"
#import "UIHomeworkEditViewController.h"
#import "KnowLedgePoint.h"
#import "UIHomeworkSettingViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "YYFPSLabel.h"

typedef NS_ENUM(NSInteger, ADDHOMEWORK){
    HOMEWORKTITLE,
    SUBMMITTIME,
    KNOWLEDGE
};
typedef NS_ENUM(NSInteger, BottomMethod){
    NoSelectorItem = 0,
    SelectorItem,
    Method_Cancel
};
typedef NS_ENUM(NSInteger, CELLHEIGHT){
    NOPICANDAUDIO = 65,
    ONELINEPIC = 165,
    TWOLINEPIC = 267
};

@interface UIHomeworkAddHomeworkViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIHomeworkAddDelegate,UIHomeworkBottomDelegate,UIHomeworkAddDetailDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *knowledge;
@property (nonatomic, strong) NewHomeWorkSend *baseHome;
@property (nonatomic, strong) NewHomeworkFileSend *baseHomeInfo;
@end

@implementation UIHomeworkAddHomeworkViewController{
    NSArray *cellTitles;
    NSArray *cellPlaceHold;
    NSString *homeworkTitles;
    UIView *pickerContainer;
    UIDatePicker *datePicker;
    UIView *backgroudView;
    UIHomeworkBottomView *bottomView;
    NSIndexPath *homeworkindex;
}
- (instancetype)initWithHomework:(NewHomeWorkSend*)homework  withIndex:(NSIndexPath*)homeworkIndex{
    self = [super init];
    if (self) {
        self.baseHome = homework;
        homeworkindex = homeworkIndex;
    }
    return self;
}
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initIvar];
    [self initNav];
    [self.view addSubview:self.table];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem = nil;
    if ((((NewHomeworkFileSend*)([self.baseHome.items lastObject])).item_answer == nil && (self.baseHome.items.count !=0 && [((NewHomeworkFileSend*)([self.baseHome.items lastObject])).item_type isEqualToString:@"1"])) || ([((NewHomeworkFileSend*)([self.baseHome.items lastObject])).item_imgscnt isEqualToString:@"0"] && ((NewHomeworkFileSend*)([self.baseHome.items lastObject])).item_info == nil&& ((NewHomeworkFileSend*)([self.baseHome.items lastObject])).item_audio == nil)) {
        [self.baseHome.items removeLastObject];
    }
    [self.table reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.updateTable) {
        [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.baseHome.items.count] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        self.updateTable = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews{
    [self initTable];
}
#pragma mark - init Method
- (void)initView{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"新增作业";
    
    backgroudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroudView.alpha = 0.3;
    backgroudView.backgroundColor = [UIColor blackColor];
    backgroudView.userInteractionEnabled = NO;
    backgroudView.hidden = YES;
    bottomView = [[UIHomeworkBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 135) style:UITableViewStylePlain withTitle:@[@"非选择题",@"选择题",@"取消"]];
    bottomView.homeworkBottomDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:backgroudView];
    [[UIApplication sharedApplication].keyWindow addSubview:bottomView];
    
    
}
- (void)initNav{
    if ([self.navigationController.viewControllers count] == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"cancel") style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    }
    UIBarButtonItem *right_save;
    if ([self.navigationController.viewControllers count] == 1) {
//        right_save = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"collection_icon_pressed") style:UIBarButtonItemStylePlain target:self action:@selector(saveForWork:)];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        [btn addTarget:self action:@selector(deleteDraft:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:IMAGE(@"collection_icon_pressed") forState:UIControlStateNormal];
        right_save = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    else{
//        right_save = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"collection_icon_normal") style:UIBarButtonItemStylePlain target:self action:@selector(saveForWork:)];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        [btn addTarget:self action:@selector(saveForWork:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:IMAGE(@"collection_icon_normal") forState:UIControlStateNormal];
        right_save = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
//    UIBarButtonItem *right_send = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"sent") style:UIBarButtonItemStylePlain target:self action:@selector(sendForWork)];
    self.navigationItem.rightBarButtonItems = @[right_save];
    self.navigationItem.titleView = [[YYFPSLabel alloc] initWithFrame:CGRectZero];
}
- (void)initIvar{
    self.knowledge = [NSMutableArray array];
    cellTitles = @[@"作业标题",@"提交时间",@"知识点"];
    cellPlaceHold = @[@"请填写作业题目",@"请选择作业提交时间",@"请填写知识点(可多个)"];
}
- (void)initTable{
    self.table.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT-64-44);
    UIButton *dosureHomework = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44 - 64, SCREEN_WIDTH, 44)];
    [dosureHomework setTitle:@"确认出题" forState:UIControlStateNormal];
    dosureHomework.backgroundColor = STYLE_COLOR;
    [dosureHomework addTarget:self action:@selector(sendForWork) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dosureHomework];
}
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 45;
    }
    else{
        CGFloat collectionHeight;
        NSInteger picNum = [((NewHomeworkFileSend*)(self.baseHome.items[indexPath.section -1])) picNum];
        if (picNum == 0){
            collectionHeight = 0;
        }
        else if (picNum >3){
            collectionHeight = 190;
        }
        else{
            collectionHeight = 100;
        }
        
        return collectionHeight + [tableView fd_heightForCellWithIdentifier:@"UIHomeworkAddDetailCell" cacheByIndexPath:indexPath configuration:^(UIHomeworkAddDetailCell *cell) {
            [cell loadItemDataForHeight:self.baseHome.items[indexPath.section -1]];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + self.baseHome.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0?3:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIHomeworkAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeworkAddCell"];
        cell.title.text = cellTitles[indexPath.row];
        cell.editField.placeholder = cellPlaceHold[indexPath.row];
        switch (indexPath.row) {
            case 2:{
                cell.editField.tag = 1001;
                cell.editField.delegate = self;
                cell.UIHomeworkAddDelegate = self;
                if (self.baseHome.knowledgepoints == nil || [self.baseHome.knowledgepoints isEqualToString:@""]) {
                    cell.editField.text = [self getKnowledgePointsName:self.knowledge];
                    self.baseHome.knowledgepoints = [self getKnowledgePoints:self.knowledge];
                    self.baseHome.knowledges = [self getKnowledgePointsName:self.knowledge];
                }
                else{
                    if (self.knowledge.count) {
                        self.baseHome.knowledgepoints = [self getKnowledgePoints:self.knowledge];
                        self.baseHome.knowledges = [self getKnowledgePointsName:self.knowledge];
                    }
                    cell.editField.text = self.baseHome.knowledges;
                }
            }
                break;
            case 1:{
                cell.editImageView.hidden = YES;
                cell.editField.enabled = NO;
                if (self.baseHome.submittime != nil || ![self.baseHome.submittime isEqualToString:@""]) {
                    cell.editField.text = self.baseHome.submittime;
                }
                break;
            }
            case 0:{
                cell.editImageView.hidden = YES;
                if (self.baseHome.title == nil || [self.baseHome.title isEqualToString:@""]) {
                    cell.editField.text = homeworkTitles;
                }
                else{
                    cell.editField.text = self.baseHome.title;
                }
                cell.editField.delegate = self;
            }
        }
        return cell;
    }
    else{
        UIHomeworkAddDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeworkAddDetailCell"];
        cell.itemNum.text = [NSString stringWithFormat:@"第%ld项",indexPath.section];
        cell.addDetailDelegate = self;
        cell.currentIndex = indexPath;
        [cell loadItemData:self.baseHome.items[indexPath.section -1] withCapacity:self.baseHome.items.count];
        return cell;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case SUBMMITTIME:
                [self showSubmitTime];
                break;
            case KNOWLEDGE:
                [self showKnowledge];
                break;
            default:
                break;
        }
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除该项";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.baseHome.items removeObjectAtIndex:indexPath.section -1];
    [self.table reloadData];
}
#pragma mark - UIHomeworkAddDetailDelegate
- (void)didTouchHomeworkPic:(NSInteger)index withIndex:(NSIndexPath *)indexPath{
    UFOFeedImageViewController *vc = [[UFOFeedImageViewController alloc]initWithPicArray:[((NewHomeworkFileSend*)(self.baseHome.items[indexPath.section -1])) stringToArray] andCurrentDisplayIndex:index];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1001) {
        textField.text = [self getKnowledgePointsName:self.knowledge];
        return;
    }
    homeworkTitles = textField.text;
    self.baseHome.title = textField.text;
    [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UIHomeworkAddDelegate
- (void)addKnowledge{
    [self showKnowledge];
    
}
#pragma mark - UIHomeworkBottomDelegate
- (void)bottomViewMethod:(NSIndexPath*)path{
    [self pushBottomView];
    switch (path.row) {
        case NoSelectorItem:
            [self pushNoselectorVC];
            break;
        case SelectorItem:
            [self pushSelectorVC];
            break;
        case Method_Cancel:
            break;
        default:
            break;
    }
}
#pragma mark - event respond
- (void)sendForWork{
    if (homeworkTitles == nil && self.baseHome.title == nil) {
        [MBProgressHUD showError:@"请填写作业题目"];
        return;
    }
    UIHomeworkAssignMentVC *vc = [[UIHomeworkAssignMentVC alloc] init];
    vc.baseHome = self.baseHome;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)saveForWork:(UIButton*)sender{
    if ( (homeworkTitles == nil && self.baseHome.title == nil)||(self.baseHome.submittime == nil)) {
        [MBProgressHUD showError:@"请完善作业基本信息"];
        return;
    }
    NSMutableArray *listModel  = [NSMutableArray arrayWithArray:[NewHomeWorkSend readListModelForKey:@"NewHomeWorkSend"]];
    [listModel addObject:self.baseHome];
    BOOL res = [NewHomeWorkSend saveListModel:listModel forKey:@"NewHomeWorkSend"];
    if (res) {
        NSLog(@"SUCCESS");
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.5)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        [sender.layer addAnimation:k forKey:@"SHOW"];
        [sender setImage:IMAGE(@"collection_icon_pressed") forState:UIControlStateNormal];
        [sender removeTarget:self action:@selector(saveForWork:) forControlEvents:UIControlEventTouchUpInside];
        [sender addTarget:self action:@selector(deleteDraft:) forControlEvents:UIControlEventTouchUpInside];
        [MBProgressHUD showSuccess:@"已保存到草稿"];
    }
    else{
        NSLog(@"失败");
    }
}
- (void)deleteDraft:(UIButton*)sender{
    NSMutableArray *homeworks = [NSMutableArray arrayWithArray:[NewHomeWorkSend readListModelForKey:@"NewHomeWorkSend"]];
    [homeworks removeObjectAtIndex:homeworkindex.row];
    BOOL res = [NewHomeWorkSend saveListModel:homeworks forKey:@"NewHomeWorkSend"];
    if (res) {
        NSLog(@"SUCCESS");
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.5)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        [sender.layer addAnimation:k forKey:@"SHOW"];
        [sender setImage:IMAGE(@"collection_icon_normal") forState:UIControlStateNormal];
        [MBProgressHUD showSuccess:@"已删除该作业草稿"];
        [self.table reloadData];
        [sender removeTarget:self action:@selector(deleteDraft:) forControlEvents:UIControlEventTouchUpInside];
        [sender addTarget:self action:@selector(saveForWork:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        NSLog(@"失败");
    }
}
- (void)dismissVC{
    [self pushBottomView];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)pushNoselectorVC{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.baseHome.items addObject:[[NewHomeworkFileSend alloc] init]];
    ((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_type = @"0";
    UIHomeworkEditViewController *vc = [[UIHomeworkEditViewController alloc] initWithNibName:@"UIHomeworkEditViewController" bundle:nil];
    vc.baseHome = self.baseHome;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushSelectorVC{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.baseHome.items addObject:[[NewHomeworkFileSend alloc] init]];
    ((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_type = @"1";
    UIHomeworkSettingViewController *vc = [[UIHomeworkSettingViewController alloc]initWithNibName:@"UIHomeworkSettingViewController" bundle:nil];
    vc.baseHome = self.baseHome;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)popBottomView{
    [[UIApplication sharedApplication].keyWindow addSubview:backgroudView];
    if (__CGPointEqualToPoint(bottomView.frame.origin, CGPointMake(0, SCREEN_HEIGHT-135))) {
        backgroudView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 135);
        } completion:^(BOOL finished) {
            bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 135);
        }];
    }
    else{
        backgroudView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-135, SCREEN_WIDTH, 135);
        } completion:^(BOOL finished) {
            bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-135, SCREEN_WIDTH, 135);
        }];
    }
}
- (void)pushBottomView{
    backgroudView.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 135);
    } completion:^(BOOL finished) {
        bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 135);
    }];
}

/**
 *  添加一想具体作业
 */
- (void)doAddItem{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.baseHome.items addObject:[[NewHomeworkFileSend alloc] init]];
    ((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_type = @"0";
    UIHomeworkSettingViewController *vc = [[UIHomeworkSettingViewController alloc]initWithNibName:@"UIHomeworkSettingViewController" bundle:nil];
    vc.baseHome = self.baseHome;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 *  显示提交时间
 */
- (void)showSubmitTime{
    if(pickerContainer == nil)
    {
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.backgroundColor = [UIColor whiteColor];
        pickerContainer = [[UIView alloc] init];
        
        [pickerContainer addSubview:datePicker];
        
        UIView *topView = [[UIView alloc] init];
        [pickerContainer addSubview:topView];
        topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
        topView.backgroundColor = [UIColor grayColor];
        
        UIButton *btnComplete = [UIButton buttonWithType:UIButtonTypeCustom];
        [topView addSubview:btnComplete];
        btnComplete.frame = CGRectMake(SCREEN_WIDTH - 10 - 100, 0, 100, 49);
        [btnComplete setTitle:@"完成" forState:UIControlStateNormal];
        [btnComplete addTarget:self action:@selector(doSureTime) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [topView addSubview:btnCancel];
        btnCancel.frame = CGRectMake(10, 0, 100, 49);
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(doCancelTime) forControlEvents:UIControlEventTouchUpInside];
        
    }
    pickerContainer.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, datePicker.frame.size.height + 50);
    datePicker.frame = CGRectMake(0, 50, SCREEN_WIDTH, datePicker.frame.size.height);
    [LayerCustom showWithView:pickerContainer];
}
- (void)doSureTime
{
    UIHomeworkAddCell *cell = (UIHomeworkAddCell*)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    
    cell.editField.text = [datePicker.date format:@"MM月dd日  HH:mm"];
    self.baseHome.submittime = [datePicker.date format:@"yyyy-MM-dd HH:mm:ss"];
    [self doCancelTime];
}

- (void)doCancelTime
{
    [LayerCustom hide];;
}
/**
 *  进入选知识点界面
 */
- (void)showKnowledge{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIHomeworkKnowledgeAddViewController *vc = [[UIHomeworkKnowledgeAddViewController alloc] initWithNibName:@"UIHomeworkKnowledgeAddViewController" bundle:nil];
    vc.displayKnowledgePoints = self.knowledge;
    vc.baseHomeWork = self.baseHome;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)getKnowledgePointsName:(NSArray *)data{
    NSMutableString *temp = [NSMutableString string];
    [data enumerateObjectsUsingBlock:^(KnowLedgePoint *obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [temp appendString:obj.knowledgepointname];
        }
        else{
            [temp appendFormat:@"/%@",obj.knowledgepointname];
        }
    }];
    return temp;
}

- (NSString *)getKnowledgePoints:(NSArray *)data{
    NSMutableString *temp = [NSMutableString string];
    [data enumerateObjectsUsingBlock:^(KnowLedgePoint *obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [temp appendString:obj.knowledgepointid];
        }
        else{
            [temp appendFormat:@",%@",obj.knowledgepointid];
        }
    }];
    return temp;
}
#pragma getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE_ForNote(UITableViewStylePlain);
        [_table registerNib:[UINib nibWithNibName:@"UIHomeworkAddCell" bundle:nil] forCellReuseIdentifier:@"UIHomeworkAddCell"];
        [_table registerNib:[UINib nibWithNibName:@"UIHomeworkAddDetailCell" bundle:nil] forCellReuseIdentifier:@"UIHomeworkAddDetailCell"];
        _table.delegate = self;
        _table.dataSource = self;
        _table.showsVerticalScrollIndicator = NO;
        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UIButton *btnAddItem = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAddItem.layer.masksToBounds = YES;
        btnAddItem.layer.cornerRadius = 5;
        btnAddItem.backgroundColor = [UIColor whiteColor];
        [btnAddItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnAddItem.frame = CGRectMake(0, 0, SCREEN_WIDTH - 10, 55);
        [btnAddItem setTitle:@"添加题目" forState:UIControlStateNormal];
        [btnAddItem setImage:IMAGE(@"add_grey") forState:UIControlStateNormal];
        btnAddItem.backgroundColor = RGB(0, 198, 176);
        [btnAddItem addTarget:self action:@selector(doAddItem) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:btnAddItem];
        _table.tableFooterView = bg;
    }
    return _table;
}
- (NewHomeWorkSend*)baseHome{
    if (_baseHome == nil) {
        _baseHome = [[NewHomeWorkSend alloc] init];
    }
    return _baseHome;
}
- (void)setUpdateTable:(BOOL)updateTable{
    _updateTable = updateTable;
}
@end
