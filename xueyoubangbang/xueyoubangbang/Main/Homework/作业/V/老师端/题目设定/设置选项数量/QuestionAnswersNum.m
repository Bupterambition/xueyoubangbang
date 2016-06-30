//
//  QuestionAnswersNum.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/24.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "QuestionAnswersNum.h"
@interface QuestionAnswersNum()
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
@implementation QuestionAnswersNum

- (void)awakeFromNib {
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    self.minusButton.layer.masksToBounds = YES;
    self.minusButton.layer.cornerRadius = 17.5;
    self.minusButton.layer.borderColor = STYLE_COLOR.CGColor;
    self.addButton.layer.masksToBounds = YES;
    self.addButton.layer.cornerRadius = 17.5;
    self.addButton.layer.borderColor = STYLE_COLOR.CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)didTouchMinus:(UIButton *)sender {
    if (self.answerNumLabel.text.integerValue <3) {
        [CommonMethod showAlert:@"最少要选择两种答案"];
        return;
    }
    NSInteger value = self.answerNumLabel.text.integerValue;
    self.answerNumLabel.text = [NSString stringWithFormat:@"%ld",(value - 1)];
    if ([self.AnswerItemNumDelegate respondsToSelector:@selector(didChangeSelectorAnswerItemNum:)]) {
        [self.AnswerItemNumDelegate didChangeSelectorAnswerItemNum:self.answerNumLabel.text.integerValue];
    }
}

- (IBAction)didTouchAdd:(UIButton *)sender {
    if (self.answerNumLabel.text.integerValue>=8) {
        [CommonMethod showAlert:@"最多选择八种答案"];
        return;
    }
    NSInteger value = self.answerNumLabel.text.integerValue;
    self.answerNumLabel.text = [NSString stringWithFormat:@"%ld",value +1];
    if ([self.AnswerItemNumDelegate respondsToSelector:@selector(didChangeSelectorAnswerItemNum:)]) {
        [self.AnswerItemNumDelegate didChangeSelectorAnswerItemNum:self.answerNumLabel.text.integerValue];
    }
}
@end
