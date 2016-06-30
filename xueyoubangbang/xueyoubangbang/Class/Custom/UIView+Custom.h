//
//  UIView+FindFirstResponder.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/19.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Custom)
- (id)findFirstResponder;
- (CGFloat)bottomY;
- (CGFloat)rightX;
- (void)addRedPoint;
- (void)addRedPointWithOffset:(CGPoint)offset;
- (void)removeRedPoint;
@end
