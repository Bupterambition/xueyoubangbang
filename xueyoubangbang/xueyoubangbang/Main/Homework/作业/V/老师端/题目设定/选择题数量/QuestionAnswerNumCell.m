//
//  QuestionAnswerNumCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/24.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "QuestionAnswerNumCell.h"
@interface QuestionAnswerNumCell()
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@end
@implementation QuestionAnswerNumCell

- (void)awakeFromNib {
    self.minusButton.layer.masksToBounds = YES;
    self.minusButton.layer.cornerRadius = 17.5;
    self.minusButton.layer.borderColor = STYLE_COLOR.CGColor;
    self.addButton.layer.masksToBounds = YES;
    self.addButton.layer.cornerRadius = 17.5;
    self.addButton.layer.borderColor = STYLE_COLOR.CGColor;
    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView = backView;
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (IBAction)didTouchMinus:(UIButton *)sender {
    if (self.questionNumLabel.text.integerValue <=1) {
        [CommonMethod showAlert:@"最少有一道题"];
        return;
    }
    NSInteger value = self.questionNumLabel.text.integerValue;
    self.questionNumLabel.text = [NSString stringWithFormat:@"%ld",value -1];
    if ([self.questionAnswerNumDelegate respondsToSelector:@selector(didChangeSelectorNum:)]) {
        [self.questionAnswerNumDelegate didChangeSelectorNum:self.questionNumLabel.text.integerValue];
    }
}

- (IBAction)didTouchAdd:(UIButton *)sender {
    NSInteger value = self.questionNumLabel.text.integerValue;
    NSLog(@"%ld",value);
    self.questionNumLabel.text = [NSString stringWithFormat:@"%ld",value+1];
    if ([self.questionAnswerNumDelegate respondsToSelector:@selector(didChangeSelectorNum:)]) {
        [self.questionAnswerNumDelegate didChangeSelectorNum:self.questionNumLabel.text.integerValue];
    }
}
@end
