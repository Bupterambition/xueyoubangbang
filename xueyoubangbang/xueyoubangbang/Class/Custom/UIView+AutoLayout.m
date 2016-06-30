//
//  UIView+Common.m
//  client
//
//  Created by sdzhu on 15/3/23.
//  Copyright (c) 2015年 supaide. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView(AutoLayout)
- (NSLayoutConstraint *)constraintCenterXToItemCenterX:(id)view constant:(CGFloat)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:constant];
    
    return c;
}

- (NSLayoutConstraint *)constraintRightToItemCenterX:(id)view constant:(CGFloat)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:constant];
    
    return c;
}

- (NSLayoutConstraint *)constraintLeftToItemCenterX:(id)view constant:(CGFloat)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:constant];
    
    return c;
}

- (NSLayoutConstraint *)constraintLeftToItemLeft:(id)view constant:(CGFloat)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:constant];
    
    return c;
}

- (NSLayoutConstraint *)constraintRightToItemRight:(id)view constant:(CGFloat)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:constant];
    
    return c;
}

- (NSLayoutConstraint *)constraintTopToItemTop:(id)view constant:(CGFloat)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:constant];
    
    return c;
}

- (NSLayoutConstraint *)constraintBottomToItemBottom:(id)view constant:(CGFloat)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:constant];
    
    return c;
}

- (NSLayoutConstraint *)constraintTopToItemBottom:(id)view constant:(CGFloat)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:constant];
    
    return c;
}

- (NSLayoutConstraint *)constraintBottomToItemTop:(id)view constant:(CGFloat)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:constant];
    
    return c;
}

- (NSLayoutConstraint *)constraintWidth:(CGFloat)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:constant];
    
    return c;
}

- (NSLayoutConstraint *)constraintHeight:(CGFloat)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:constant];
    
    return c;
}

- (NSLayoutConstraint *)constraintWidthToItem:(id)view constant:(CGFloat)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1 constant:constant];
    return c;
}

- (NSLayoutConstraint *)constraintHeightToItem:(id)view constant:(CGFloat)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1 constant:constant];
    return c;
}

- (NSLayoutConstraint *)constraintWithFirstAttribute:(NSLayoutAttribute)firstAttribute secondItem:(id)secondItem secondAttribute:(NSLayoutAttribute)secondAttribute
{
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if (constraint.firstItem == self && constraint.firstAttribute == firstAttribute && constraint.secondAttribute && constraint.secondItem == secondItem) {
            return constraint;
        }
    }
    return nil;
}

@end
