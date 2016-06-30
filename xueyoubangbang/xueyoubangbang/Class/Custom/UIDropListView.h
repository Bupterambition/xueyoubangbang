//
//  UIDropListView.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/20.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DropListViewDelegate <NSObject>
@optional
- (void) onChooseItem:(NSInteger)row;

@end

@interface UIDropListView : UIView<UITableViewDataSource,UITableViewDelegate>
- (id) initWithFrame:(CGRect)frame itemHeight:(CGFloat)itemHeight data:(NSArray *)data;
@property (nonatomic,weak) id<DropListViewDelegate> delegate;
@property (nonatomic,copy) NSArray *data;
@property (nonatomic,readonly) CGFloat height;
@property (nonatomic,strong,readonly) UITableView *table;
@end
