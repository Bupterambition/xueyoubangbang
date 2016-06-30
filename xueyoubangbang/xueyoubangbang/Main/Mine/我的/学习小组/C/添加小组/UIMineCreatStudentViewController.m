//
//  CreatStudentViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/8/29.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineCreatStudentViewController.h"
#import "StudentGroupViewModel.h"
#import "MBProgressHUD+MJ.h"
@interface UIMineCreatStudentViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *subjectName;
@property (weak, nonatomic) IBOutlet UITextField *subject;
@property (weak, nonatomic) IBOutlet UITableView *subjectList;
@property (weak, nonatomic) IBOutlet UIButton *popButton;

@end

@implementation UIMineCreatStudentViewController{
    NSArray *subjects;
    CGRect originTableFrame;
    CGRect currentTableFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建作业小组";
    subjects = @[@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"地理",@"历史",@"政治"];
    [self addDisappearForSubjectlist];
    [self addCreatButton];
    [self addDisapperForSubjectname];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    originTableFrame = _subjectList.frame;
    CGRect frame = originTableFrame;
    frame.size = CGSizeMake(frame.size.width, 0);
    currentTableFrame = frame;
    _subjectList.frame = frame;
}

#pragma mark - init Method
- (void)addDisapperForSubjectname{
    _subjectName.delegate = self;
}
- (void)addCreatButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(CreatStudentGroup)];
}
- (void)addDisappearForSubjectlist{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushSubjects)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
#pragma mark -UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SUBJECT"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SUBJECT"];
    }
    cell.textLabel.text = subjects[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _subject.text = subjects[indexPath.row];
    [self pushSubjects];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}
#pragma mark - event Respont
//弹出学科列表
- (IBAction)popSubjects:(UIButton *)sender {
    [_subjectName resignFirstResponder];
    if (sender.selected) {
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:M_PI];
        rotationAnimation.toValue = [NSNumber numberWithFloat: 0];
        rotationAnimation.duration = 0.2;
        rotationAnimation.fillMode = kCAFillModeForwards;
        rotationAnimation.removedOnCompletion = NO;
        [sender.layer addAnimation:rotationAnimation forKey:@"pushanimateTransform"];
        [self pushSubjects];
        return;
    }
    else{
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
        rotationAnimation.duration = 0.2;
        rotationAnimation.cumulative = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        rotationAnimation.removedOnCompletion = NO;
        [sender.layer addAnimation:rotationAnimation forKey:@"pushanimateTransform"];
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _subjectList.frame = originTableFrame;
    } completion:^(BOOL finished) {
        _subjectList.frame = originTableFrame;
        sender.selected = YES;
    }];
}
- (void)pushSubjects{
    if (_popButton.selected) {
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:M_PI];
        rotationAnimation.toValue = [NSNumber numberWithFloat: 0];
        rotationAnimation.duration = 0.2;
        rotationAnimation.fillMode = kCAFillModeForwards;
        rotationAnimation.removedOnCompletion = NO;
        [_popButton.layer addAnimation:rotationAnimation forKey:@"pushanimateTransform"];
    }
    [UIView animateWithDuration:0.3 animations:^{
        _subjectList.frame = currentTableFrame;
    } completion:^(BOOL finished) {
        _subjectList.frame = currentTableFrame;
        _popButton.selected = NO;
    }];
}
/**
 *  创建学习小组
 */
- (void)CreatStudentGroup{
    [_subjectName resignFirstResponder];
    if ([subjects containsObject:_subject.text]) {
        [StudentGroupViewModel CreatStudentGroupwithparameters:@{@"userid":[GlobalVar instance].user.userid,@"groupname":_subjectName.text,@"subject":_subject.text} withCallBack:^(NSString *groupID, BOOL success) {
            if (success) {
                [MBProgressHUD showSuccess:@"创建成功"];
                _subject.text = nil;
                _subjectName.text = nil;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"学科填写错误" message:@"请填写正确的学科" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
