//
//  UICustomNavigationViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/19.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UICustomNavigationViewController.h"

@interface UICustomNavigationViewController ()<UIGestureRecognizerDelegate>{
    UIViewController *_customRootViewController;
}
@end

@implementation UICustomNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addFullScreenGuesture];
    if(IOS_VERSION_7_OR_ABOVE){
        //设置返回按钮背景色
        self.navigationBar.tintColor = [UIColor whiteColor];
        //设置导航栏颜色
        self.navigationBar.barTintColor = STYLE_COLOR;
        self.navigationBar.translucent = NO;
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    else{
        self.navigationBar.backgroundColor = STYLE_COLOR;
    }
    
}

- (void)addFullScreenGuesture{
    id target = self.interactivePopGestureRecognizer.delegate;
    
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;

}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController{
    _customRootViewController = rootViewController;

    self = [super initWithRootViewController:rootViewController];
    if(self){
        UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
        returnButtonItem.title = @"返回";
        rootViewController.navigationItem.backBarButtonItem = returnButtonItem;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(viewController != _customRootViewController){
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"返回";
    viewController.navigationItem.backBarButtonItem = returnButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
