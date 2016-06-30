//
//  UIInterActAllViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/29.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIInterActAllViewController.h"
#import "UIInterActAskMeViewController.h"
#import "UIInterActMyQuestionViewController.h"
#import "UIInterActAskViewController.h"
static const CGFloat kSegmentedItemWidth = 72.f;

@interface UIInterActAllViewController ()
@property(strong, nonatomic) UISegmentedControl *segmentControl;
@property(weak, nonatomic) UIViewController *currentViewController;
@property(strong, nonatomic) NSArray *viewControllers;
@end

@implementation UIInterActAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[
                                                                      NSLocalizedString(@"向我提问", nil),
                                                                      NSLocalizedString(@"我的提问", nil)
                                                                      ]];
    for (int i = 0; i < self.segmentControl.numberOfSegments; i++) {
        [self.segmentControl setWidth:kSegmentedItemWidth forSegmentAtIndex:i];
    }
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget:self
                            action:@selector(segmentChanged:)
                  forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentControl;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(didGotoAsk)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self segmentChanged:self.segmentControl];
}

- (void)segmentChanged:(UISegmentedControl *)sender {
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    
    UIViewController *vc = [self viewControllerForSegmentIndex:sender.selectedSegmentIndex];
    vc.edgesForExtendedLayout = UIRectEdgeNone;
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height = CGRectGetHeight([UIScreen mainScreen].bounds) - 64;
    vc.view.frame = frame;
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    
    self.currentViewController = vc;
    self.navigationItem.title = vc.title;
}

- (void)didGotoAsk{
    UIInterActAskViewController *vc = [[UIInterActAskViewController alloc] initWithNibName:@"UIInterActAskViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    if (!self.viewControllers) {
        self.viewControllers = @[
                                 [[UIInterActAskMeViewController alloc] init],
                                 [[UIInterActMyQuestionViewController alloc] init],
                                 ];
    }
    return self.viewControllers[index];
}

@end
