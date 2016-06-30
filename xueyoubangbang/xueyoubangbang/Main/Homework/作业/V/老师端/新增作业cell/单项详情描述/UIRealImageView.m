//
//  UIRealImageView.m
//  xueyoubangbang
//
//  Created by Bob on 15/12/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIRealImageView.h"
#import "UIEditImageView.h"
@implementation UIRealImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.editImageView = [[UIEditImageView alloc] initWithFrame:frame];
        [self addSubview:self.editImageView];
        self.userInteractionEnabled = NO;
    }
    return self;
}
-(CGRect)getFrameSizeForImage:(UIImage *)image inImageView:(UIImageView *)imageView {
    
    CGFloat hfactor = image.size.width / imageView.frame.size.width;
    CGFloat vfactor = image.size.height / imageView.frame.size.height;
    
    CGFloat factor = fmax(hfactor, vfactor);
    
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    CGFloat newWidth = image.size.width / factor;
    CGFloat newHeight = image.size.height / factor;
    
    // Then figure out if you need to offset it to center vertically or horizontally
    CGFloat leftOffset = (imageView.frame.size.width - newWidth) / 2;
    CGFloat topOffset = (imageView.frame.size.height - newHeight) / 2;
    self.editImageView.frame = CGRectMake(leftOffset, topOffset, newWidth, newHeight);
    NSLog(@"%@",NSStringFromCGRect(CGRectMake(leftOffset, topOffset, newWidth, newHeight)));
    return CGRectMake(leftOffset, topOffset, newWidth, newHeight);
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@",touches);
}

#pragma mark - event Respond
- (void)clearAllCheckLine{
    [self.editImageView clearAction];
}
- (void)undoLastAction{
    [self.editImageView undoAction];
}
@end
