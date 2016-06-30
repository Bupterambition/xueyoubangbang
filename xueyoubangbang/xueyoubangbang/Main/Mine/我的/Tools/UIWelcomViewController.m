//
//  UIWelcomViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/15.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIWelcomViewController.h"
#import "UILoginViewController.h"
#import "MainTabViewController.h"
@interface UIWelcomViewController()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}
@end

@implementation UIWelcomViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *images;
    CGFloat btnY;
    CGFloat pageControlY;
    btnY = SCREEN_HEIGHT - 120;
    if( SCREEN_HEIGHT == SCREEN_IPHONE_4)
    {
        images = @[@"welcome480_1",@"welcome480_2",@"welcome480_3"];
        
        pageControlY = 480;
    }
    else if(SCREEN_HEIGHT == SCREEN_IPHONE_5)
    {
        images = @[@"welcome568_1",@"welcome568_2",@"welcome568_3"];
//        btnY = 365;
        pageControlY = 420;
    }
    else if(SCREEN_HEIGHT == SCREEN_IPHONE_6)
    {
        images = @[@"welcome667_1",@"welcome667_2",@"welcome667_3"];
        btnY = SCREEN_HEIGHT - 200;;
        pageControlY = 420;
    }
    else
    {
        images = @[@"welcome2000_1",@"welcome2000_2",@"welcome2000_3"];
//        btnY = 365;
        pageControlY = 200;
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    int const kCount = 3;
    for (int i = 0;i < kCount; i++)
    {
        CGRect itemFrame = CGRectMake(i * w, 0, w, h);
        UIView *viewContainer = [[UIView alloc] initWithFrame:itemFrame];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        UIImage *image = [UIImage imageNamed:[images objectAtIndex:i]];
        [imageView setImage:image];
        
        [viewContainer addSubview:imageView];
        
        if (i == kCount - 1)
        {
            
            UIButton *btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
            CGSize btnSize = [UIImage imageNamed:@"welcome_btn_normal"].size;
            [btnStart setImage:[UIImage imageNamed:@"welcome_btn_normal"] forState:UIControlStateNormal];
            [btnStart setImage:[UIImage imageNamed:@"welcome_btn_active"] forState:UIControlStateHighlighted];
            btnStart.frame = CGRectMake(SCREEN_WIDTH / 2 - btnSize.width / 2, btnY, btnSize.width, btnSize.height);
            [btnStart addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
            [viewContainer addSubview:btnStart];
        }
        
        [_scrollView addSubview:viewContainer];
    }
    _scrollView.contentSize = CGSizeMake(kCount * w, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
//    _pageControl = [[UIPageControl alloc] init];
//    _pageControl.center = CGPointMake(w * 0.5, pageControlY);
//    _pageControl.bounds = CGRectMake(0, 0, 150, 50);
//    _pageControl.numberOfPages = kCount; // 一共显示多少个圆点（多少页）
//    // 设置非选中页的圆点颜色
//    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0xcd/255.0f green:0xcd/255.0f blue:0xcd/255.0f alpha:1.0];
//    // 设置选中页的圆点颜色
//    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0xc2/255.0f green:0x1d/255.0f blue:0x19/255.0f alpha:1.0];
//    
//    // 禁止默认的点击功能
//    _pageControl.enabled = NO;
    // [self.view addSubview:_pageControl];
    
}

- (void)doLogin
{
    if(self.isStart)
    {
        if([GlobalVar instance].user == nil)
        {
            UICustomNavigationViewController *nva = [[UICustomNavigationViewController alloc] initWithRootViewController:[[UILoginViewController alloc] init]];
            mainWindow.rootViewController = nva;
        }
        else
        {
            MainTabViewController *mainTab = [[MainTabViewController alloc]init];
            mainWindow.rootViewController = mainTab;
        }

    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
