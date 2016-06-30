//
//  UIHomeworkAddGroupVCForS.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/15.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkAddGroupVCForS.h"
#import "UIHomeworkAddGroupForS.h"
#import "UIHomeworkViewModel.h"
#import "UIHomeworkApplyGroupsForsFirst.h"
#import "RCDraggableButton.h"
#import "UIHomeworkListFors.h"
#import "StudentGroup.h"
#import "UIHomeworkAddGroupViewModel.h"
#import "UIInterActAllViewController.h"
@interface UIHomeworkAddGroupVCForS ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *addGroupDisplay;
@property (strong, nonatomic) UIHomeworkAddGroupViewModel *viewModel;
@end

@implementation UIHomeworkAddGroupVCForS{
    NSMutableArray *subjectGroups;
}
#pragma mark - life Method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseView];
    [self initSignal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -init Method
- (void)initBaseView{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.addGroupDisplay.dataSource = self.viewModel;
    [self.addGroupDisplay registerNib:[UINib nibWithNibName:@"UIHomeworkAddGroupForS" bundle:nil] forCellWithReuseIdentifier:@"UIHomeworkAddGroupForS"];
    [self.addGroupDisplay addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getAddedGroups)];
    [self.addGroupDisplay.legendHeader beginRefreshing];
    self.title = @"作业";
    //添加＋悬浮按钮
    weak(weakself);
    RCDraggableButton *avatar = [[RCDraggableButton alloc] initInView:self.view WithFrame:CGRectMake(220, 150, 60, 60)];
    [avatar setBackgroundImage:[UIImage imageNamed:@"btn_interact"] forState:UIControlStateNormal];
    [avatar setTapBlock:^(RCDraggableButton *avatar) {
        [weakself goToInterAct];
    }];
    [avatar setDragDoneBlock:^(RCDraggableButton *avatar) {
    }];
}
- (void)initSignal{
    weak(weakself);
    [self.viewModel.loadCommond.executionSignals.switchToLatest subscribeNext:^(id x) {
        if ([x isEqualToString:@"suc"]) {
            [weakself.addGroupDisplay reloadData];
            [weakself.addGroupDisplay.header endRefreshing];
        }
    }];
}
- (void)getAddedGroups{
    [self.viewModel.loadCommond execute:nil];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.row == self.viewModel.subjectGroups.count) {
        UIHomeworkApplyGroupsForsFirst *vc = [[UIHomeworkApplyGroupsForsFirst alloc] initWithNibName:@"UIHomeworkApplyGroupsForsFirst" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        UIHomeworkListFors *vc =[[UIHomeworkListFors alloc] init];
        vc.groupid = [(StudentGroup*)self.viewModel.subjectGroups[indexPath.row] getGroupID];
        vc.title = [(StudentGroup*)self.viewModel.subjectGroups[indexPath.row] getSubject];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (isRetina || iPhone5) {
        return CGSizeMake(98, 98);
    }
    if (iPhone6) {
        return CGSizeMake(117, 117);
    }
    if (iPhone6plus) {
        return CGSizeMake(130, 130);
    }
    return CGSizeMake(98, 98);
}
#pragma mark - event response
- (void)goToInterAct{
    UIInterActAllViewController *vc = [[UIInterActAllViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - setter and getter 
- (UIHomeworkAddGroupViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[UIHomeworkAddGroupViewModel alloc] init];
    }
    return _viewModel;
}
@end
