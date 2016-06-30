//
//  UIHomeworkAnswerDelegate.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/10.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIHomeworkAnswerDelegate <NSObject>
/**
 *  row是答案，section是题号
 *
 *  @param index 前面是答案，后面是题号
 *  @param currentindex 具体位置索引，用于多个section中
 */
- (void)didTouchAnswerWithIndex:(NSIndexPath *)index andCurrentIndex:(NSIndexPath*)currentindex;
/**
 *  row是答案，section是题号
 *
 *  @param index        前面是答案，后面是题号
 *  @param currentindex 具体位置索引，用于多个section中
 */
- (void)didTouchMutilAnswerWithIndex:(NSIndexPath *)index andCurrentIndex:(NSIndexPath*)currentindex;
@end
