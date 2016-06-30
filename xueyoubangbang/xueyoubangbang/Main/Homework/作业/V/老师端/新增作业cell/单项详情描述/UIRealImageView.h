//
//  UIRealImageView.h
//  xueyoubangbang
//
//  Created by Bob on 15/12/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIEditImageView.h"
@interface UIRealImageView : UIImageView
@property (nonatomic, strong)UIEditImageView *editImageView;
-(CGRect)getFrameSizeForImage:(UIImage *)image inImageView:(UIImageView *)imageView;
/**
 *  清楚所有画线批注
 */
- (void)clearAllCheckLine;
/**
 *  撤销上一步动作
 */
- (void)undoLastAction;
@end
