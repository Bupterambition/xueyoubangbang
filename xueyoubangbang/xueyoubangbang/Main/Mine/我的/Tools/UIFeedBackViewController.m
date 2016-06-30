//
//  UIFeedBackViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/3.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIFeedBackViewController.h"
@interface UIFeedBackViewController()<UITextViewDelegate>
{
    UITextView *input;
    
    UITextView *placeHolderView;
}
@end
@implementation UIFeedBackViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createView];
}

- (void)createView
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"意见反馈";
    
    UIView *container = [[UIView alloc] init];
    container.frame = CGRectMake(0, 20, SCREEN_WIDTH, 140);
    container.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:container];
    
    
    placeHolderView = [[UITextView alloc] init];
    placeHolderView.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 100);
    placeHolderView.textColor = UIColorFromRGB(0xeaeaea);
    placeHolderView.editable = NO;
    placeHolderView.text = @"请在方框内输入您的意见和建议，您的支持是我们成长的动力:-D";
    [container addSubview:placeHolderView];
    
    input = [[UITextView alloc] init];
    input.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 100);
    input.backgroundColor =[UIColor clearColor];
    input.delegate = self;
    [container addSubview:input];
    
    
    UIButton *btn = BUTTON_CUSTOM([container bottomY] + 50);
    [self.view addSubview:btn];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doSubmit) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{    if (![text isEqualToString:@""])
    
{
    
    placeHolderView.hidden = YES;
    
}
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        
        placeHolderView.hidden = NO;
        
    }
    
    return YES;
    
}



- (void)doSubmit
{
    if (input.text == nil) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    [AFNetClient GlobalGet:kUrlFeedback parameters:[CommonMethod getParaWithOther:@{@"feedback":input.text}] success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        if(isUrlSuccess(dataDict))
        {
            [CommonMethod showAlert:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [CommonMethod showAlert:urlErrorMessage(dataDict)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        [CommonMethod showAlert:@"提交失败"];
    }];
}

@end
