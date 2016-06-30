//
//  UIEditImageView.h
//  xueyoubangbang
//
//  Created by Bob on 15/12/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIEditImageView : UIView
{
    CGMutablePathRef path;
    NSMutableArray *pathModalArray;
}

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
- (void)undoAction;
- (void)clearAction;

@end
