//
//  NoSelectorForsCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NoSelectorForsCellDelegate <NSObject>
/**
 *  删除图片
 *
 *  @param index        某一行cell中的图片的位置
 *  @param currentIndex ell的位置
 */
- (void)didTouchDelete:(NSInteger)index withIndex:(NSIndexPath*)currentIndex;
/**
 *  点击放大
 *
 *  @param index        某一行cell中的图片的位置
 *  @param currentIndex cell的位置
 */
- (void)didTouchHomeworkPic:(NSInteger)index withIndex:(NSIndexPath*)currentIndex;
/**
 *  点击拍照
 *
 *  @param currentIndex cell的位置
 */
- (void)didTouchPicWithIndex:(NSIndexPath*)currentIndex;
@end


@interface NoSelectorForsCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, weak) id<NoSelectorForsCellDelegate> noSelectorForsCellDelegate;

- (void)loadPic:(NSArray*)photos;
@end
