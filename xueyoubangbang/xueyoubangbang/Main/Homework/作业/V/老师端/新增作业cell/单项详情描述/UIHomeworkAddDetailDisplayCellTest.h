//
//  UIHomeworkAddDetailDisplayCellTest.h
//  xueyoubangbang
//
//  Created by Bob on 15/12/27.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIHomeworkAddDetailDisplayCellTest : UICollectionViewCell
/**
 *  加载图片
 *
 *  @param img 图片
 *  @param key 图片标示
 */
- (void)loadImg:(UIImage *)img withKey:(NSString *)key;
- (void)loadVoice:(UIImage *)img;
@end
