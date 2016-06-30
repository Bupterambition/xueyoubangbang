//
//  UIHomeworkDetailCellTableViewCell.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHomeworkItem.h"
@interface UIHomeworkDetailCellTableViewCell : UITableViewCell
@property (nonatomic,weak) UILabel *leftTopLabel;
@property (nonatomic,weak) UIButton *rightTopButton;
@property (nonatomic,weak) UIImageView *rightIcon;
@property (nonatomic,weak) UIImageView *picture;
@property (nonatomic,weak) UILabel *mainTextLabel;
- (void)settingData:(MHomeworkItem *)item;

@end


@interface UIHomeworkDetailTableViewCellFrame : NSObject
@property (nonatomic) CGRect picturesF;
@property (nonatomic) CGRect voiceF;
@property (nonatomic) CGRect mainTextF;
@property (nonatomic) CGFloat bottomContainerY;
@property (nonatomic) CGFloat middelContainerH;
@property (nonatomic) CGFloat cellHeight;
-(id)initWithHomeworkItem:(MHomeworkItem *)item;
@end
