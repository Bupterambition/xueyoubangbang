//
//  UIHomeworkCommentViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkCommentViewController.h"
#import "BRPlaceholderTextView.h"
#import "MBProgressHUD+MJ.h"
#import "UIHomeworkCheckDetailViewController.h"
@interface UIHomeworkCommentViewController ()<UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *placeTextView;


@end

@implementation UIHomeworkCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkEvaluate];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    [self.placeTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[UIHomeworkCheckDetailViewController class]]) {
        ((UIHomeworkCheckDetailViewController*)viewController).evaluate = self.evaluate;
    }
    self.navigationController.delegate = nil;
}
#pragma mark - event response
- (void)commit{
    if (self.placeTextView.text.length == 0) {
        [CommonMethod showAlert:@"请填写评语"];
        return;
    }
    [self.placeTextView resignFirstResponder];
    self.evaluate = self.placeTextView.text;
    [MBProgressHUD showSuccess:@"已添加评语"];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - private Method
- (void)checkEvaluate{
    if ([CommonMethod isBlankString:self.evaluate]) {
        self.placeTextView.placeholder = @"请填写评语，您最多能输入200个字";
        self.placeTextView.maxTextLength = 200;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    }
    else{
        self.placeTextView.placeholder = @"请填写评语，您最多能输入200个字";
        self.placeTextView.maxTextLength = 200;
        self.placeTextView.text = self.evaluate;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重新提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    }
}
@end
