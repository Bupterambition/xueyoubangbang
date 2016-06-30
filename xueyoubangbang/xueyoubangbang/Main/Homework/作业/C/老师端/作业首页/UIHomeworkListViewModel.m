//
//  UIHomeworkListViewModel.m
//  xueyoubangbang
//
//  Created by Bob on 15/12/31.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkListViewModel.h"
#import "UIHomeworkViewModel.h"
#import "UIHomeworkMainCell.h"
@interface UIHomeworkListViewModel()<UIHomeCellMainDelegate>
@end
@implementation UIHomeworkListViewModel{
    NSInteger currentPageIndex;
}
#pragma mark - init Method
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initBaseSignal];
    }
    return self;
}

- (void)initBaseSignal{
    [self creatLoadSignal];
    [self creatMoreLoadSignal];
}
/**
 *  构建加载命令
 */
- (void)creatLoadSignal{
    weak(weakself);
    self.loadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *loadSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            currentPageIndex = 1;
            weakself.finishUpdate = NO;
            [UIHomeworkViewModel getHomeworkListWithParams:[self getNewPara:currentPageIndex] withCallBack:^(NSArray *homeworkList) {
                currentPageIndex ++;
                [subscriber sendNext:homeworkList];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
        return loadSignal;
    }];
    
    [[[self.loadCommand executionSignals] switchToLatest] subscribeNext:^(id x) {
        weakself.homeworks = x;
        weakself.finishUpdate = YES;
    }];
}
/**
 *  构建加载更多命令
 */
- (void)creatMoreLoadSignal{
    weak(weakself);
    self.moreLoadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *moreLoadSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            weakself.finishUpdate = NO;
            [UIHomeworkViewModel getHomeworkListWithParams:[self getNewPara:currentPageIndex+1] withCallBack:^(NSArray *homeworkList) {
                if (homeworkList != nil && homeworkList.count !=0) {
                    currentPageIndex ++;
                    [subscriber sendNext:homeworkList];
                    [subscriber sendCompleted];
                }
                else if (homeworkList != nil){
                    [subscriber sendNext:homeworkList];
                    [subscriber sendCompleted];
                }
                else{
                    [subscriber sendError:nil];
                    [subscriber sendCompleted];
                }
            }];
            return nil;
        }];
        return moreLoadSignal;
    }];
    [[self.moreLoadCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
        [weakself.homeworks addObjectsFromArray:x];
        weakself.finishUpdate = YES;
    }];
}

#pragma mark - event Response

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.homeworks.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
#define rightLable1Tag 10000
#define rightLable2Tag 10001
#define CELL_HEIGTH 60
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIHomeworkMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeworkMainCell"];
    cell.currentIndex = indexPath;
    cell.homeCellDelegate = self;
    [cell loadNewHomeWorkData:self.homeworks[indexPath.section]];
    return cell;
}
#pragma mark - private Method
- (NSDictionary *)getNewPara:(NSInteger)pageIndex{
    if([rolesUser isEqualToString:roleTeacher]) {
        return @{@"userid":[GlobalVar instance].user.userid,@"pageIndex":[NSNumber numberWithInteger:pageIndex],@"pageSize":kPageSize};
    }
    else {
        return @{@"userid":[GlobalVar instance].user.userid,@"groupid":[GlobalVar instance].user.key,@"pageIndex":[NSNumber numberWithInteger:pageIndex],@"pageSize":kPageSize};
    }
}
#pragma mark -setter and getter
- (RACSignal *)cellDelegateSignal{
    if (_cellDelegateSignal == nil) {
        _cellDelegateSignal = [self rac_signalForSelector:@selector(didTouchButton:) fromProtocol:@protocol(UIHomeCellMainDelegate)];
    }
    return _cellDelegateSignal;
}
- (NSMutableArray *)homeworks{
    if (_homeworks == nil) {
        _homeworks = [NSMutableArray array];
    }
    return _homeworks;
}
- (RACSubject *)tableSubject{
    if (_tableSubject == nil) {
        _tableSubject = [RACSubject subject];
    }
    return _tableSubject;
}
@end
