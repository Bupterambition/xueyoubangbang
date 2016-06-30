//
//  ZoomScrollView.h
//  xueyoubangbang
//
//  Created by Bob on 16/1/20.
//  Copyright (c) 2016年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomScrollView : UIScrollView
- (void)displayImage:(UIImage *)image;
-(void)zoomImage:(UIGestureRecognizer *)tap;
@end
