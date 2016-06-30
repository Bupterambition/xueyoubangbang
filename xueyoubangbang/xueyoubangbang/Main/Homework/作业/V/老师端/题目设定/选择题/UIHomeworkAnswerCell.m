//
//  UIHomeworkAnswer.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/10.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkAnswerCell.h"

@implementation UIHomeworkAnswerCell{
    BOOL ifMutilSelector;
}

- (void)awakeFromNib {
    for (NSInteger index = 1001; index <1009; index++) {
        UIView *view = [self.contentView viewWithTag:index];
        view.layer.masksToBounds = YES;
        view.layer.borderWidth = 1;
        view.layer.borderColor = STYLE_COLOR.CGColor;
    }
    self.answerItem.adjustsFontSizeToFitWidth = YES;
    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView = backView;
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)didTouchAnswer:(UIButton *)sender {
    if (ifMutilSelector) {
        [self reverseButtonForMutil:sender];
        if ([self.answerDelegate respondsToSelector:@selector(didTouchMutilAnswerWithIndex:andCurrentIndex:)]) {
            [self.answerDelegate didTouchMutilAnswerWithIndex:[NSIndexPath indexPathForRow:sender.tag-1000 inSection:self.currentPath.row ] andCurrentIndex:self.currentPath];//前面是答案，后面是题号
        }
    }
    else{
        BOOL ifSame = [self reverseButton:sender];
        if (ifSame) {
            if ([self.answerDelegate respondsToSelector:@selector(didTouchAnswerWithIndex: andCurrentIndex:)]) {
                [self.answerDelegate didTouchAnswerWithIndex:[NSIndexPath indexPathForRow:sender.tag-1000 inSection:self.currentPath.row ] andCurrentIndex:self.currentPath];//前面是答案，后面是题号
            }
        }
        else{
            if ([self.answerDelegate respondsToSelector:@selector(didTouchAnswerWithIndex: andCurrentIndex:)]) {
                [self.answerDelegate didTouchAnswerWithIndex:[NSIndexPath indexPathForRow:0 inSection:self.currentPath.row ] andCurrentIndex:self.currentPath];//前面是答案，后面是题号
            }
        }
    }
    
}
- (void)loadSelector:(NSNumber*)answer{
    ifMutilSelector = NO;
    UIButton *btn = (UIButton*)[self.contentView viewWithTag:1000+[answer integerValue]];
    for (NSInteger index = 1001; index <1009; index++) {
        UIButton *view = (UIButton*)[self.contentView viewWithTag:index];
        view.selected = NO;
        view.backgroundColor = [UIColor whiteColor];
    }
    btn.selected = YES;
    btn.backgroundColor = STYLE_COLOR;
}
- (void)hideExcessButton:(NSInteger)num{
    for (NSInteger index = 1001; index <1001+num; index++) {
        UIButton *view = (UIButton*)[self.contentView viewWithTag:index];
        view.hidden = NO;
    }
    for (NSInteger index = 1001+num; index <1009; index++) {
        UIButton *view = (UIButton*)[self.contentView viewWithTag:index];
        view.hidden = YES;
    }
}
- (void)loadMutilSelector:(NSArray*)answer{
    ifMutilSelector = YES;
    for (NSInteger index = 1001; index <1009; index++) {
        UIButton *view = (UIButton*)[self.contentView viewWithTag:index];
        view.selected = NO;
        view.backgroundColor = [UIColor whiteColor];
    }
    [answer enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = (UIButton*)[self.contentView viewWithTag:1000+[obj integerValue]];
        btn.selected = YES;
        btn.backgroundColor = STYLE_COLOR;
    }];
    
}
- (BOOL)reverseButton:(UIButton*)sender{
    for (NSInteger index = 1001; index <1009; index++) {
        UIButton *view = (UIButton*)[self.contentView viewWithTag:index];
        if (view.selected) {
            if (view.tag == sender.tag) {
                sender.backgroundColor = [UIColor whiteColor];
                sender.selected = !sender.selected;
                return NO;
            }else{
                view.selected = NO;
                view.backgroundColor = [UIColor whiteColor];
                sender.selected = !sender.selected;
                sender.backgroundColor = STYLE_COLOR;
            }
            break;
        }
        else if (index == 1008){
            sender.selected = !sender.selected;
            sender.backgroundColor = STYLE_COLOR;
        }
    }
    return YES;
}
- (void)reverseButtonForMutil:(UIButton*)sender{
    for (NSInteger index = 1001; index <1009; index++) {
        UIButton *view = (UIButton*)[self.contentView viewWithTag:index];
        if (view.tag == sender.tag) {
            if (view.selected) {
                sender.backgroundColor = [UIColor whiteColor];
                sender.selected = !sender.selected;
            }
            else{
                sender.backgroundColor = STYLE_COLOR;
                sender.selected = !sender.selected;
            }
        }
    }
}
@end
