//
//  Toast.m
//  EnglishWeekly
//
//  Created by 杨宇 on 14-4-11.
//  Copyright (c) 2014年 杨宇. All rights reserved.
//

#import "Toast.h"
#import <QuartzCore/QuartzCore.h>
static NSMutableArray *_myToastArrayList;
@interface Toast (private)

- (id)initWithText:(NSString *)text_;
- (void)setDuration:(CGFloat) duration_;

- (void)dismisToast;
- (void)toastTaped:(UIButton *)sender_;

- (void)showAnimation;
- (void)hideAnimation;

- (void)show;
- (void)showFromTopOffset:(CGFloat) topOffset_;
- (void)showFromBottomOffset:(CGFloat) bottomOffset_;
-(void)doNext;
@end


@implementation Toast
@synthesize text;
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:[UIDevice currentDevice]];
}


- (id)initWithText:(NSString *)text_{
    if (self = [super init]) {
        
        //初始化队列
        if (!_myToastArrayList){
            _myToastArrayList = [[NSMutableArray alloc] initWithCapacity:1];
        }
        
        text = [text_ copy];
        
        UIFont *font = [UIFont boldSystemFontOfSize:16];
        CGSize textSize = [text sizeWithFont:font
                           constrainedToSize:CGSizeMake(280, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 12, textSize.height + 12)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = font;
        textLabel.text = text;
        textLabel.numberOfLines = 0;
        
        contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];
        contentView.layer.cornerRadius = 5.0f;
        contentView.layer.borderWidth = 1.0f;
        contentView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        contentView.backgroundColor = [UIColor colorWithRed:0.2f
                                                      green:0.2f
                                                       blue:0.2f
                                                      alpha:0.75f];
        [contentView addSubview:textLabel];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [contentView addTarget:self
                        action:@selector(toastTaped:)
              forControlEvents:UIControlEventTouchDown];
        contentView.alpha = 0.0f;
        
        duration = DEFAULT_DISPLAY_DURATION;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationDidChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:[UIDevice currentDevice]];
        
        
    }
    return self;
}

- (void)deviceOrientationDidChanged:(NSNotification *)notify_{
    [self hideAnimation];
}

-(void)dismissToast{
    //从队列删除
    [_myToastArrayList removeObject:self];
    
    
    [contentView removeFromSuperview];
    
    if (_myToastArrayList.count >= 1){
        Toast *t = _myToastArrayList.firstObject;
        if (![t.text isEqualToString:self.text]){
            [t doNext];
        } else {
            [t dismissToast];
        }
        
        
    }
    
    
}

-(void)toastTaped:(UIButton *)sender_{
    [self hideAnimation];
}

- (void)setDuration:(CGFloat) duration_{
    duration = duration_;
}

-(void)showAnimation{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 1.0f;
    [UIView commitAnimations];
}

-(void)hideAnimation{
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 0.0f;
    [UIView commitAnimations];
}


-(void)doNext{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    contentView.center = window.center;
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

- (void)show{
    //判断是否有toast
    if (_myToastArrayList && _myToastArrayList.count >= 1){
        [_myToastArrayList addObject:self];
        return;
    }
    [_myToastArrayList addObject:self];


    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    contentView.center = window.center;
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

- (void)showFromTopOffset:(CGFloat) top_{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    contentView.center = CGPointMake(window.center.x, top_ + contentView.frame.size.height/2);
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

- (void)showFromBottomOffset:(CGFloat) bottom_{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    contentView.center = CGPointMake(window.center.x, window.frame.size.height-(bottom_ + contentView.frame.size.height/2));
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}


+ (void)showWithText:(NSString *)text_{
    [Toast showWithText:text_ duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text_
            duration:(CGFloat)duration_{
    Toast *toast = [[Toast alloc] initWithText:text_];
    [toast setDuration:duration_];
    [toast show];
}

+ (void)showWithText:(NSString *)text_
           topOffset:(CGFloat)topOffset_{
    [Toast showWithText:text_  topOffset:topOffset_ duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text_
           topOffset:(CGFloat)topOffset_
            duration:(CGFloat)duration_{
    Toast *toast = [[Toast alloc] initWithText:text_];
    [toast setDuration:duration_];
    [toast showFromTopOffset:topOffset_];
}

+ (void)showWithText:(NSString *)text_
        bottomOffset:(CGFloat)bottomOffset_{
    [Toast showWithText:text_  bottomOffset:bottomOffset_ duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text_
        bottomOffset:(CGFloat)bottomOffset_
            duration:(CGFloat)duration_{
    Toast *toast = [[Toast alloc] initWithText:text_] ;
    [toast setDuration:duration_];
    [toast showFromBottomOffset:bottomOffset_];
}

@end
