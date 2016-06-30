//
//  UIQuestionAnswerTableViewCell.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAnswer.h"

#define kMainTextFont
@interface UIQuestionAnswerTableViewCell : UITableViewCell
@property (nonatomic,weak) UIImageView *header;
@property (nonatomic,weak) UILabel *lable1;
@property (nonatomic,weak) UILabel *lable2;
@property (nonatomic,weak) UILabel *contentLable;
//@property (nonatomic,weak) UIImageView *picture;
@property (nonatomic,weak) UIView *voiceView;
- (void)settingData:( MAnswer*)answer;

@end

@interface UIQuestionAnswerTableViewCellFrame : NSObject
@property (nonatomic,assign) CGRect headerFrame;
@property (nonatomic,assign) CGRect lable1Frame;
@property (nonatomic,assign) CGRect lable2Frame;
@property (nonatomic,assign) CGRect contentLableFrame;
//@property (nonatomic,assign) CGRect picutureFrame;
@property (nonatomic,assign) CGRect voiceFrame;
@property (nonatomic,assign) CGRect topContainerFrame;
@property (nonatomic,assign) CGRect contentContainerFrame;

@property (nonatomic) CGFloat pictureH;

@property (nonatomic,assign) CGFloat cellHeight;

-(id)initWithAnswer:(MAnswer *)answer;
@end

