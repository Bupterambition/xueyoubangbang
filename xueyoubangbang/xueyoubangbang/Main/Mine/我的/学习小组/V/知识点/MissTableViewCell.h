//
//  MissTableViewCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/26.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissTableViewCell : UITableViewCell
/**
 *  填充数据
 *
 *  @param data 错误率数据
 *  @param days 数据有效天
 *  @param index 当前数据记录
 */
- (void)loadData:(NSArray*)data withValidDays:(NSArray*)days withIndex:(NSIndexPath*)index;
@end
