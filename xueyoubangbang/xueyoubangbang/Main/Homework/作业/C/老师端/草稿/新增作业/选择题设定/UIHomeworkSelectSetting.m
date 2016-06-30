//
//  UIHomeworkSelectSetting.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/10.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkSelectSetting.h"
#import "UIHomeworkAddCell.h"
#import "UIHomeworkAnswerCell.h"
#import "UIHomeworkAnwser.h"
#import "NSMutableArray+Capacity.h"
#import "UIHomeworkEditViewController.h"
#import "NewHomeWorkSend.h"
#import "NewHomeworkFileSend.h"
@interface UIHomeworkSelectSetting ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIHomeworkAnswerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NewHomeWorkSend *baseHome;
@property (nonatomic, strong) NewHomeworkFileSend *baseHomeInfo;
@end

@implementation UIHomeworkSelectSetting{
    NSMutableArray *answers;
    NSInteger questionNum;
}
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self.view addSubview:self.table];
    [self initIvar];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - init Method
- (instancetype)initWithHomeWork:(NewHomeWorkSend*)homework{
    self = [super init];
    if (self) {
        self.baseHome = homework;
    }
    return self;
}
- (void)initView{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"设置选择题";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(addHomeworkDetail)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappearEdit)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
- (void)initIvar{
    answers = [NSMutableArray array];
}


#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return questionNum == 0?1:2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0?1:questionNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    else{
        return 96;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section) {
        UIHomeworkAnwser *view = [[NSBundle mainBundle]loadNibNamed:@"UIHomeworkAnwser" owner:self options:nil][0];
        return view;
    }
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UIHomeworkAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeworkAddCell"];
        cell.title.text = @"选择题数量";
        cell.title.adjustsFontSizeToFitWidth = YES;
        cell.editImageView.hidden = YES;
        cell.editField.delegate = self;
        cell.editField.placeholder = @"请输入选择题数量";
        cell.editField.returnKeyType = UIReturnKeyDone;
        [cell.editField becomeFirstResponder];
        if (questionNum != 0) {
            cell.editField.text = [NSString stringWithFormat:@"%ld",questionNum];
        }
        return cell;
    }
    else{
        UIHomeworkAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeworkAnswerCell"];
        cell.currentPath = indexPath;
        cell.answerItem.text = [NSString stringWithFormat:@"%ld",(indexPath.row + 1)];
        cell.answerDelegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}

#pragma mark - UIHomeworkAnswerDelegate
- (void)didTouchAnswerWithIndex:(NSIndexPath *)index andCurrentIndex:(NSIndexPath*)currentindex{
    [answers replaceObjectAtIndex:index.section withObject:NSIntToNumber(index.row)];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (([string integerValue]<= 0 && ![string isEqualToString:@"0"]) || ([string integerValue]<= 0 && range.location == 0 )) {
        if (![string  isEqual:@""]) {
            return NO;
        }
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    questionNum = [textField.text integerValue];
    answers = [NSMutableArray initAnswerWithCapacity:questionNum];
    [self.table reloadData];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -event respond
- (void)disappearEdit{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (void)addHomeworkDetail{
    if (answers.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先设置选择题答案" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([answers containsObject:@0]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有选择题未设置答案" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    ((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_answer =[answers componentsJoinedByString:@","];
    UIHomeworkEditViewController *vc = [[UIHomeworkEditViewController alloc] initWithNibName:@"UIHomeworkEditViewController" bundle:nil];
    vc.baseHome = self.baseHome;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma private Method
-(NSDictionary *)getPara:(NSInteger)pageIndex{
    NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key,@"pageIndex":[NSNumber numberWithInteger:pageIndex],@"pageSize":kPageSize};
    NSLog(@"homelist para = %@",para);
    return para;
}

#pragma getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE(UITableViewStylePlain);
        _table.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT - 64);
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerNib:[UINib nibWithNibName:@"UIHomeworkAnswerCell" bundle:nil] forCellReuseIdentifier:@"UIHomeworkAnswerCell"];
        [_table registerNib:[UINib nibWithNibName:@"UIHomeworkAddCell" bundle:nil] forCellReuseIdentifier:@"UIHomeworkAddCell"];
    }
    return _table;
}
@end
