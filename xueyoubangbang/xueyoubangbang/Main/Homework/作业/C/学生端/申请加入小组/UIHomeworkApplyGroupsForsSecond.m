//
//  UIHomeworkApplyGroupsForsSecond.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/15.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkApplyGroupsForsSecond.h"
#import "UIHomeworkViewModel.h"
#import "UIHomeworkApplyGroupsForsThird.h"
@interface UIHomeworkApplyGroupsForsSecond ()
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UILabel *groupNum;
@property (weak, nonatomic) IBOutlet UIButton *appleBtn;

@end

@implementation UIHomeworkApplyGroupsForsSecond

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加小组";
    self.groupName.text = self.groupDic[@"groupname"];
    self.groupNum.text = self.groupDic[@"teachername"];
}
- (void)viewWillLayoutSubviews{
    self.appleBtn.layer.masksToBounds = YES;
    self.appleBtn.layer.cornerRadius = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -event response
//学习组id：groupid， 学生id：studentid
- (IBAction)applyGroup:(id)sender {
    UIHomeworkApplyGroupsForsThird *vc = [[UIHomeworkApplyGroupsForsThird alloc] initWithNibName:@"UIHomeworkApplyGroupsForsThird" bundle:nil];
    vc.groupDic = self.groupDic;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
