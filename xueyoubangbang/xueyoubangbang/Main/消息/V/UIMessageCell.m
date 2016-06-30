//
//  UIMessageCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMessageCell.h"
#import "UIMessageModels.h"
#import "StudentGroup.h"
@interface UIMessageCell()
@property (weak, nonatomic) IBOutlet UILabel *leftUpLabel;

@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *trueImage;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@end
@implementation UIMessageCell{
    CGRect leftUPFrame ;
    CGRect leftDownFrame;
}

- (void)awakeFromNib {
    self.title.adjustsFontSizeToFitWidth = YES;
    //    self.trueImage.layer.masksToBounds = YES;
    //    self.trueImage.layer.cornerRadius = self.trueImage.frame.size.height/2;
    //    self.trueImage.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.leftUpLabel.adjustsFontSizeToFitWidth = YES;
    
    leftUPFrame = self.leftUpLabel.frame;
    leftDownFrame = self.leftDownLabel.frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)loadData:(StudentGroup*)data withIndex:(NSInteger)index{
    if (index == 0){
        self.classLabel.text = [(StudentGroup*)data groupname];
        //        self.title.text = [(StudentGroup*)data title];
        self.leftDownLabel.hidden = YES;
        self.ImageView.image = IMAGE(@"message_subject_icon");
    }
    else{
        self.classLabel.text = [(StudentGroup*)data groupname];
        //        self.title.text = [(StudentGroup*)data title];
        self.leftUpLabel.text = @"查看批改";
        self.leftUpLabel.hidden = YES;
        self.leftDownLabel.text = @"已批改";
        self.ImageView.image = IMAGE(@"message_subject_icon");
    }
}

- (void)loadData:(id)data{
    self.classLabel.center = CGPointMake(self.classLabel.center.x, 20.5);
    if ([data isKindOfClass:[ApplyForFriends class]]){
        self.classLabel.text = [NSString stringWithFormat:@"%@申请成为好友",[(ApplyForFriends*)data applicant]];
        self.classLabel.center = CGPointMake(self.classLabel.center.x, 31.5);
        self.title.hidden = YES;
        self.leftDownLabel.hidden = YES;
        self.leftUpLabel.hidden = NO;
        self.leftUpLabel.text = [(ApplyForFriends*)data remind_time];
        self.ImageView.image = IMAGE(@"message_newfriends_icon");
    }
    else if ([data isKindOfClass:[ApplyForGroup class]]){
        self.classLabel.text = [NSString stringWithFormat:@"%@申请加入%@",[(ApplyForGroup*)data studentname],[(ApplyForGroup*)data groupname]];
        self.classLabel.center = CGPointMake(self.classLabel.center.x, 31.5);
        self.title.hidden = YES;
        self.leftDownLabel.hidden = YES;
        self.leftUpLabel.hidden = NO;
        self.leftUpLabel.text = [(ApplyForFriends*)data remind_time];
        self.ImageView.image = IMAGE(@"message_group_icon");
    }
    else if ([data isKindOfClass:[HomeworkFinished class]]){
        self.classLabel.text = [NSString stringWithFormat:@"%@ %@",[(HomeworkFinished*)data groupname],[(HomeworkFinished*)data getSubject]];
        self.title.hidden = NO;
        self.title.text = [(HomeworkFinished*)data title];
        //        self.leftDownLabel.frame = leftDownFrame;
        //        self.leftUpLabel.frame = leftUPFrame;
        self.leftUpLabel.hidden = NO;
        self.leftUpLabel.text = @"立即批阅";
        self.leftDownLabel.hidden = NO;
        self.leftDownLabel.text = [NSString stringWithFormat:@"%@人完成",[(HomeworkFinished*)data finishnum]];
        self.ImageView.image = IMAGE(@"新批改提醒");//IMAGE([(HomeworkChecked*)data getSubject]);
    }
    else if ([data isKindOfClass:[HomeworkToDo class]]){
        self.classLabel.text = [NSString stringWithFormat:@"%@ %@",[(HomeworkToDo*)data groupname],[(HomeworkToDo*)data getSubject]];
        //        self.title.text = [(StudentGroup*)data title];
        self.title.hidden = NO;
        self.title.text = @"老师布置新的作业啦";
        self.leftUpLabel.hidden = NO;
        self.leftUpLabel.center = CGPointMake(self.leftUpLabel.center.x, 31.5);
        self.leftDownLabel.hidden = YES;
        self.ImageView.image = IMAGE(@"新作业提醒");
    }
    else if ([data isKindOfClass:[HomeworkChecked class]]){
        self.classLabel.text = [NSString stringWithFormat:@"%@ %@",[(HomeworkChecked*)data groupname],[(HomeworkChecked*)data getSubject]];
        self.title.hidden = NO;
        self.title.text = [NSString stringWithFormat:@"%@老师批改了你的作业",[(HomeworkChecked*)data getSubject]];
        //        self.leftUpLabel.frame = leftUPFrame;
        self.leftUpLabel.text = @"查看批改";
        self.leftUpLabel.hidden = YES;
        self.leftDownLabel.center = CGPointMake(self.leftDownLabel.center.x, 31.5);
        self.leftDownLabel.text = @"已批改";
        self.leftDownLabel.hidden = NO;
        self.ImageView.image = IMAGE(@"新批改提醒");
    }
    else{
        self.classLabel.text = @"互动圈";
        //        self.leftUpLabel.frame = leftUPFrame;
        self.title.hidden = NO;
        self.title.text = [NSString stringWithFormat:@"%@在互动圈中@到我",[(Question*)data sendername]];
        self.leftDownLabel.hidden = YES;
        self.leftUpLabel.hidden = NO;
        self.leftUpLabel.text = [(ApplyForFriends*)data remind_time];
        self.ImageView.image = IMAGE(@"message_interactive_icon");
    }
    
}

- (void)didTouchReview{
    if ([self.messageDelegate respondsToSelector:@selector(didTouchReview:)]) {
        [self.messageDelegate didTouchReview:self.index];
    }
}

@end
