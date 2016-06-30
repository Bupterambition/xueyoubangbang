//
//  InterActDetailCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/29.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "InterActDetailCell.h"
#import "AnswerObject.h"
#import "NSString+Stackoverflow.h"
#import "UFOFeedImageViewController.h"
#import "UIInterActDetailViewController.h"
#import "UIHomeworkViewModel.h"
#import "AudioPlayer.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface InterActDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *answerDec;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *disagreeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *ansImg;
@property (weak, nonatomic) IBOutlet UIImageView *audioImg;

@end
@implementation InterActDetailCell{
    AnswerObject *answer;
    AudioPlayer *recorder;
}

- (void)awakeFromNib {
    self.ansImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchAnswerPic)];
    [self.ansImg addGestureRecognizer:tap];
    
    self.audioImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchAudio)];
    [self.audioImg addGestureRecognizer:tap1];
    
    [self.agreeBtn addTarget:self action:@selector(agreeTheAnswer:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)loadData:(AnswerObject *)data{
    answer = data;
    self.answerDec.text = data.txt;
    if (data.image.length >4) {
        [self.ansImg sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg(data.image)] placeholderImage:DEFAULT_PIC];
        if (data.audio.length >0) {
            recorder = [[AudioPlayer alloc] init];
            recorder.audioUrl = answer.audio;
            self.audioImg.image = IMAGE(@"voice_icon");
        }
        else
            self.audioImg.image = nil;
    }
    else{
        if (data.audio.length >4) {
            recorder = [[AudioPlayer alloc] init];
            recorder.audioUrl = answer.audio;
            self.ansImg.image = IMAGE(@"voice_icon");
        }
        else
            self.ansImg.image = nil;
    }
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg(data.header_photo)] placeholderImage:DEFAULT_HEADER_f];
    self.timeLabel.text = [data.inserttime transTimeWithOriginFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"HH:mm分"];
    self.classLabel.text = @"北京一中初一三班";
    self.nameLabel.text = data.username;
    [self.agreeBtn setTitle:data.thumbup forState:UIControlStateNormal];
    [self.disagreeBtn setTitle:data.thumbdown forState:UIControlStateNormal];
}
- (IBAction)agreeTheAnswer:(UIButton *)sender {
    weak(weakself);
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [sender.imageView.layer addAnimation:k forKey:@"SHOW"];
    [UIHomeworkViewModel evaluateanswerWithParams:@{@"userid":UserID,@"answerid":answer.answer_id,@"type":@1} withCallBack:^(BOOL success, NSInteger num) {
        if (success) {
            [weakself.agreeBtn setTitle:NSIntTOString(num) forState:UIControlStateNormal];
        }
    }];
}
- (IBAction)disagreeTheAnswer:(UIButton *)sender {
    weak(weakself);
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [sender.imageView.layer addAnimation:k forKey:@"SHOW"];
    [UIHomeworkViewModel evaluateanswerWithParams:@{@"userid":UserID,@"answerid":answer.answer_id,@"type":@0} withCallBack:^(BOOL success, NSInteger num) {
        if (success) {
            [weakself.disagreeBtn setTitle:NSIntTOString(num) forState:UIControlStateNormal];
        }
    }];
}
- (void)didTouchAnswerPic{
    if (answer.image.length > 4) {
        UFOFeedImageViewController *vc = [[UFOFeedImageViewController alloc] initWithCheckPicArray:@[answer.image] andCurrentDisplayIndex:0];
        [(UIInterActDetailViewController*)(self.nextResponder.nextResponder.nextResponder.nextResponder) presentViewController:vc animated:YES completion:nil];
    }
    else{
        [self didTouchAudio];
    }
    
}
- (void)didTouchAudio{
   ((void(*)(id,SEL, unsigned long))objc_msgSend)(recorder, @selector(doPlayOrStop:),nil);
}

@end
