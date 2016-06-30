//
//  UIHomeworkAddDetailDelegate.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/11.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIHomeworkCheckDetailDelegate <NSObject>
- (void)didTouchHomeworkPic:(NSInteger)index withIndex:(NSIndexPath *)indexPath;
@optional
/**
 *  删除记事本
 *
 *  @param indexPath 记事本索引
 */
- (void)didTouchDeleteNote:(NSIndexPath*)indexPath;
@end
