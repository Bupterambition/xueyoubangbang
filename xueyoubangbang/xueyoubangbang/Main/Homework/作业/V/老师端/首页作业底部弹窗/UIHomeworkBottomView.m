//
//  UIHomeworkBottomView.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/7.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkBottomView.h"
@interface UIHomeworkBottomView()<UITableViewDataSource,UITableViewDelegate>

@end
@implementation UIHomeworkBottomView{
    NSArray *titles;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        titles = @[@"修改提交时间",@"删除作业",@"取消"];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withTitle:(NSArray *)titleArray{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        titles = titleArray;
    }
    return self;
}

#pragma mark -UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UIHomeworkBottomCell"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.homeworkBottomDelegate respondsToSelector:@selector(bottomViewMethod:)]) {
        [self.homeworkBottomDelegate bottomViewMethod:indexPath];
    }
}

@end
