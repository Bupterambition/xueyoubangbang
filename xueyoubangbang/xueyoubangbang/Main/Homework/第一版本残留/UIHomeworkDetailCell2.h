//
//  UIHomeworkDetailCell2.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHomeworkItem.h"
@interface UIHomeworkDetailCell2 : UITableViewCell
@property (nonatomic,weak) UILabel *leftTopLabel;
@property (nonatomic,weak) UIButton *rightTopButton;
@property (nonatomic,weak) UIImageView *rightIcon;

@property (nonatomic,strong)    MHomeworkItem   *homeworkItem;

@property   (nonatomic,copy)    NSString    *imageUrl;
@property   (nonatomic,strong)  UIImage     *image;
@property   (nonatomic,copy)    NSString    *desc;
@property   (nonatomic,copy)    NSString    *audioUrl;
@property   (nonatomic,strong)  NSData      *audioData;
@property (nonatomic, assign) BOOL ifAddWorkVC;
+ (CGFloat)cellHeight;
@end
