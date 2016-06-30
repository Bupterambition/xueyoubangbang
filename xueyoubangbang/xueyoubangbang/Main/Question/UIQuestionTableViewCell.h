//
//  UIQuestionTableViewCell.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQuestion.h"
@interface UIQuestionTableViewCell : UITableViewCell
@property (nonatomic,retain,readonly) UILabel *leftTop1;
@property (nonatomic,retain,readonly) UILabel *leftTop2;

@property (nonatomic,retain)    NSArray *pictures;//image
@property (nonatomic,retain,readonly) UIImageView *pictureView;
@property (nonatomic,retain,readonly) UIView    *voiceView;
@property (nonatomic,retain,readonly) UILabel *mainTextLabel;
@property (nonatomic,retain,readonly) UIImageView *userHeader;
@property (nonatomic,retain,readonly) UILabel *nicknameLabel;

@property (nonatomic,retain,readonly) UILabel *rightBottom;

- (void)settingData:(MQuestion *)question;
@end

@interface UIQuestionTableViewCellFrame : NSObject
@property (nonatomic) CGRect picturesF;
@property (nonatomic) CGRect voiceF;
@property (nonatomic) CGRect mainTextF;
@property (nonatomic) CGFloat bottomContainerY;
@property (nonatomic) CGFloat middelContainerH;
@property (nonatomic) CGFloat cellHeight;
- (id)initWithQuestion:(MQuestion *)question;
+ (UIFont *)fontMainText;
@end
