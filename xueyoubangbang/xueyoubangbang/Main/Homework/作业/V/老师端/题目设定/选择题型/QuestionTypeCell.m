//
//  QuestionTypeCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/24.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "QuestionTypeCell.h"
@interface QuestionTypeCell()
@property (weak, nonatomic) IBOutlet UIButton *noSeletorBtn;
@property (weak, nonatomic) IBOutlet UIButton *singleSelectorBtn;
@property (weak, nonatomic) IBOutlet UIButton *mutilSelectorBtn;

@end
@implementation QuestionTypeCell

- (void)awakeFromNib {
    self.noSeletorBtn.selected = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTouchNoselector:(UIButton *)sender {
    self.singleSelectorBtn.selected = NO;
    self.mutilSelectorBtn.selected = NO;
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    if ([self.questionTypeDelegate respondsToSelector:@selector(didTouchQuestionType:)]) {
        [self.questionTypeDelegate didTouchQuestionType:0];
    }
}
- (IBAction)didTouchSingleSelector:(UIButton *)sender {
    self.noSeletorBtn.selected = NO;
    self.mutilSelectorBtn.selected = NO;
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    if ([self.questionTypeDelegate respondsToSelector:@selector(didTouchQuestionType:)]) {
        [self.questionTypeDelegate didTouchQuestionType:1];
    }
}
- (IBAction)didTouchMutilSelector:(UIButton *)sender {
    self.singleSelectorBtn.selected = NO;
    self.noSeletorBtn.selected = NO;
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    if ([self.questionTypeDelegate respondsToSelector:@selector(didTouchQuestionType:)]) {
        [self.questionTypeDelegate didTouchQuestionType:2];
    }
}

@end
