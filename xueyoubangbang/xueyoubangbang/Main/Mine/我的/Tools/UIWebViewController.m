//
//  UIWebViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIWebViewController.h"

@interface UIWebViewController()
{
    UIWebView *web;
}

@end

@implementation UIWebViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    web = [[ UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:web];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [web loadRequest:request];
}



@end
