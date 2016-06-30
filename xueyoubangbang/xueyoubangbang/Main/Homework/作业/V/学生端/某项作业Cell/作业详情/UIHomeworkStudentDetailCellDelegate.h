//
//  UIHomeworkAddDetailDelegate.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/11.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIHomeworkStudentDetailDelegate <NSObject>
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
