//
//  LayerCustom.h
//  client
//
//  Created by sdzhu on 15/3/30.
//  Copyright (c) 2015年 supaide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayerCustom : UIView
@property (nonatomic,retain) UIView *showedView;
@property (nonatomic) NSInteger animateType;//0平移  1 fade
+ (LayerCustom *)showWithView:(UIView *)subview;
+ (LayerCustom *)showFadeInWithView:(UIView *)subview;
+(void)hide;
+ (void)hideFadeOut;

@end
