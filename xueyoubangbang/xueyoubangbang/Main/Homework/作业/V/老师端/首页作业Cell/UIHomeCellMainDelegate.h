//
//  UIHomeCellMainDelegate.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/7.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIHomeCellMainDelegate <NSObject>
@optional
/**
 *  修改作业项
 *
 *  @param currentIndex 当前索引
 */
- (void)didTouchButton:(NSIndexPath *)currentIndex;
@end
