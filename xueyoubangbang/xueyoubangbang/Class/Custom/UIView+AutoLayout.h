//
//  UIView+Common.h
//  client
//
//  Created by sdzhu on 15/3/23.
//  Copyright (c) 2015年 supaide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(AutoLayout)

- (NSLayoutConstraint *)constraintCenterXToItemCenterX:(id)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintRightToItemCenterX:(id)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintLeftToItemCenterX:(id)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintLeftToItemLeft:(id)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintRightToItemRight:(id)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintTopToItemTop:(id)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintBottomToItemBottom:(id)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintTopToItemBottom:(id)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintBottomToItemTop:(id)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintWidth:(CGFloat)constant;
- (NSLayoutConstraint *)constraintHeight:(CGFloat)constant;
- (NSLayoutConstraint *)constraintWidthToItem:(id)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintHeightToItem:(id)view constant:(CGFloat)constant;

- (NSLayoutConstraint *)constraintWithFirstAttribute:(NSLayoutAttribute)firstAttribute secondItem:(id)secondItem secondAttribute:(NSLayoutAttribute)secondAttribute;

@end
