//
//  UIHomeworkAddGroupViewModel.m
//  xueyoubangbang
//
//  Created by Bob on 16/1/14.
//  Copyright (c) 2016年 sdzhu. All rights reserved.
//

#import "UIHomeworkAddGroupViewModel.h"
#import "UIHomeworkViewModel.h"
#import "UIHomeworkAddGroupForS.h"
#import <ReactiveCocoa/RACEXTScope.h>
@implementation UIHomeworkAddGroupViewModel
#pragma mark - init Method
- (instancetype)init{
    self = [super init];
    if (self) {
        [self creatSignal];
    }
    return self;
}
/**
 *  创建加载信号命令
 */
- (void)creatSignal{
    @weakify(self);
    self.loadCommond = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal *loadSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [UIHomeworkViewModel getstudentGroupListWithParams:@{@"studentid":[GlobalVar instance].user.userid} withCallBack:^(NSArray *Students) {
                [self.subjectGroups removeAllObjects];
                [self.subjectGroups addObjectsFromArray:Students];
                [subscriber sendNext:@"suc"];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
        return loadSignal;
    }];
}
#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.subjectGroups.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIHomeworkAddGroupForS *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UIHomeworkAddGroupForS" forIndexPath:indexPath];
    if (indexPath.row == self.subjectGroups.count) {
        [cell loadBaseData];
    }
    else{
        [cell loadGroupData:self.subjectGroups[indexPath.row]];
    }
    return cell;
}
#pragma mark - setter and getter
- (NSMutableArray *)subjectGroups{
    if (_subjectGroups == nil) {
        _subjectGroups = [NSMutableArray array];
    }
    return _subjectGroups;
}
@end
