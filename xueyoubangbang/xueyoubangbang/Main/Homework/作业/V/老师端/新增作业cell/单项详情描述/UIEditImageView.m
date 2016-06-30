//
//  UIEditImageView.m
//  xueyoubangbang
//
//  Created by Bob on 15/12/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIEditImageView.h"
#import "PathModal.h"

@implementation UIEditImageView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        pathModalArray = [NSMutableArray array];
        self.lineColor = [UIColor redColor];
        self.lineWidth = 8.0;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    for (PathModal *modal in pathModalArray) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [modal.color setStroke];
        CGContextSetLineWidth(context, modal.width);
        CGContextAddPath(context, modal.path);
        
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    if (path != nil) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextAddPath(context, path);
        
        [self.lineColor setStroke];
        CGContextSetLineWidth(context, self.lineWidth);
        
        CGContextDrawPath(context, kCGPathStroke);
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, p.x, p.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    //点加至线上
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    //移动->重新绘图
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    PathModal *modal = [[PathModal alloc] init];
    modal.color = self.lineColor;
    modal.width = self.lineWidth;
    modal.path = path;
    
    [pathModalArray addObject:modal];
    CGPathRelease(path);
    path = nil;
}

- (void)undoAction {
    [pathModalArray removeLastObject];
    [self setNeedsDisplay];
}

- (void)clearAction {
    [pathModalArray removeAllObjects];
    [self setNeedsDisplay];
}

@end
