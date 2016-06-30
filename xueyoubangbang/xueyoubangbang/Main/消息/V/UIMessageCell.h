//
//  UIMessageCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UIMessageCellDelegate <NSObject>
- (void)didTouchReview:(NSIndexPath *)currentIndex;
@end

@class StudentGroup;
@interface UIMessageCell : UITableViewCell
@property (nonatomic, weak) id<UIMessageCellDelegate> messageDelegate;
@property (nonatomic, strong) NSIndexPath *index;
@property (weak, nonatomic) IBOutlet UILabel *leftDownLabel;
- (void)loadData:(id)data;
/**
 *  给小组填充数据
 *
 *  @param data  小组数据
 *  @param index index ＝ 0代表要去做作业；index=1代表已经批改完成
 */
- (void)loadData:(StudentGroup*)data withIndex:(NSInteger)index;
@end
