//
//  Toast.h
//  EnglishWeekly
//
//  Created by 杨宇 on 14-4-11.
//  Copyright (c) 2014年 杨宇. All rights reserved.
//

/**
 use like this
 
 [Toast showWithText:@"中间显示" duration:5];
 [Toast showWithText:@"距离上方50像素" topOffset:50 duration:5];
 [Toast showWithText:@"文字很多的时候，我就会自动折行，最大宽度280像素" topOffset:100 duration:5];
 [Toast showWithText:@"加入\\n也可以\n显示\n多\n行" topOffset:300 duration:5];
 [Toast showWithText:@"距离下方3像素" bottomOffset:3 duration:5];
 */

#import <Foundation/Foundation.h>

#define DEFAULT_DISPLAY_DURATION 2.0f

@interface Toast : NSObject {
    NSString *text;
    UIButton *contentView;
    CGFloat  duration;
}

@property (nonatomic, copy) NSString *text;

+ (void)showWithText:(NSString *) text_;
+ (void)showWithText:(NSString *) text_
            duration:(CGFloat)duration_;

+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset_;
+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset
            duration:(CGFloat) duration_;

+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_;
+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_
            duration:(CGFloat) duration_;

@end
