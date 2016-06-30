//
//  InterActCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/20.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQuestion.h"
@protocol UIInterActDelegate <NSObject>
@optional
/**
 *  点开图片
 *
 *  @param index     当前图片索引
 *  @param indexPath 当前cell索引
 */
- (void)didTouchHomeworkPic:(NSInteger)index withIndex:(NSIndexPath *)indexPath;
/**
 *  问一下
 *
 *  @param indexPath 当前cell索引
 */
- (void)didTouchAskQuestion:(NSIndexPath *)indexPath;
/**
 *  添加📒
 *
 *  @param indexPath 当前cell索引
 */
- (void)didTouchAddNote:(NSIndexPath *)indexPath;
@end


@interface InterActCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *imgsDisplay;
@property (weak, nonatomic) IBOutlet UILabel *qusetionDec;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerNum;
@property (strong, nonatomic) NSIndexPath *currentIndex;
@property (nonatomic, weak) id<UIInterActDelegate> actDelegate;
- (void)loadData:(MQuestion*)data withIndex:(NSIndexPath*)index;
@end
