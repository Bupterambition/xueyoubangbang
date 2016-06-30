//
//  UIView+FindFirstResponder.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/19.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIView+Custom.h"
#define redPointTag 12345
@implementation UIView (Custom)

- (id)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        id responder = [subView findFirstResponder];
        if (responder) return responder;
    }
    return nil;
}

- (CGFloat)bottomY
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)rightX
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)addRedPoint
{
    if([self viewWithTag:redPointTag] == nil)
    {
        UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_message_remind"]];
        v.frame = CGRectMake(self.bounds.size.width - v.frame.size.width / 2, -v.frame.size.height / 2, v.frame.size.width, v.frame.size.height);
        [self addSubview:v];
        v.tag = redPointTag;
    }
}

- (void)removeRedPoint
{
    UIView *v = [self viewWithTag:redPointTag];
    [v removeFromSuperview];
}

- (void)addRedPointWithOffset:(CGPoint)offset
{
    if([self viewWithTag:redPointTag] == nil)
    {
        UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_message_remind"]];
        v.frame = CGRectMake(offset.x, offset.y, v.frame.size.width, v.frame.size.height);
        [self addSubview:v];
        v.tag = redPointTag;
    }
}
@end
