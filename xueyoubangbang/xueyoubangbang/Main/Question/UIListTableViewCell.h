//
//  UIListTableViewCell.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIListTableViewCell : UITableViewCell

@property   (nonatomic,copy)    NSString    *imageUrl;
@property   (nonatomic,strong)  UIImage     *image;
@property   (nonatomic,copy)    NSString    *desc;
@property   (nonatomic,copy)    NSString    *audioUrl;
@property   (nonatomic,strong)  NSData      *audioData;
- (void)setImageUrl:(NSString *)imageUrl image:(UIImage *)image desc:(NSString *)desc audioUrl:(NSString *)audioUrl audioData:(NSData *)audioData;
+ (CGFloat)cellHeight;
@end
