//
//  preferViewController.m
//  Socrates
//
//  Created by shy on 15/3/8.
//  Copyright (c) 2015年 shy. All rights reserved.
//

#import "UIMineNoteAllViewController.h"
#import "UIMineAddNoteViewController.h"
#import "UIMineNoteViewController.h"
#import "UIHomeworkDraftViewController.h"

static const CGFloat kSegmentedItemWidth = 72.f;

@interface UIMineNoteAllViewController ()
@property(strong, nonatomic) UISegmentedControl *segmentControl;
@property(weak, nonatomic) UIViewController *currentViewController;
@property(strong, nonatomic) NSArray *viewControllers;

@end

@implementation UIMineNoteAllViewController{
    UIBarButtonItem *right_check;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[
                                                                      NSLocalizedString(@"我的笔记", nil),
                                                                      NSLocalizedString(@"作业草稿", nil)
                                                                      ]];
    for (int i = 0; i < self.segmentControl.numberOfSegments; i++) {
        [self.segmentControl setWidth:kSegmentedItemWidth forSegmentAtIndex:i];
    }
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget:self
                            action:@selector(segmentChanged:)
                  forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentControl;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self segmentChanged:self.segmentControl];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)initNav{
    right_check = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"add_grey") style:UIBarButtonItemStylePlain target:self action:@selector(addNote)];
    
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
    if (sender.selectedSegmentIndex == 0) {
        self.navigationItem.rightBarButtonItem = right_check;
    }
    else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    self.currentViewController = vc;
    self.navigationItem.title = vc.title;
}

- (void)addNote{
    UIMineAddNoteViewController *vc = [[UIMineAddNoteViewController alloc] initWithNibName:@"UIMineAddNoteViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    if (!self.viewControllers) {
        self.viewControllers = @[
                                 [[UIMineNoteViewController alloc] init],
                                 [[UIHomeworkDraftViewController alloc] init],
                                 ];
    }
    return self.viewControllers[index];
}

@end
