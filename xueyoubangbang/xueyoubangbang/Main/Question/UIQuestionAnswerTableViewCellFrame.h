//
//  UIQuestionAnswerTableViewCellFrame.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAnswer.h"
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
