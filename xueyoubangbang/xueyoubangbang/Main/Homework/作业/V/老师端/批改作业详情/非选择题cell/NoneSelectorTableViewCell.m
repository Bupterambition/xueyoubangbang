//
//  NoneSelectorTableViewCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "NoneSelectorTableViewCell.h"
#import "ImageGallery.h"
@interface NoneSelectorTableViewCell()<ImageGalleryDelegate>
@property (weak, nonatomic) IBOutlet ImageGallery *noneSeletorAnswer;

@end
@implementation NoneSelectorTableViewCell{
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)loadAnswerData:(NSString*)answer {
    self.noneSeletorAnswer.delegate = self;
    [self.noneSeletorAnswer loadUrlData:[answer componentsSeparatedByString:@","]];
}

- (void)loadAnswerDataForReview:(NSString*)answer withAnswerscore:(NSInteger)score{
    self.noneSeletorAnswer.delegate = self;
    [self.noneSeletorAnswer loadUrlData:[answer componentsSeparatedByString:@","]];
    UIButton *view = (UIButton*)[self.contentView viewWithTag:score+1001];
    view.highlighted = YES;
    for (NSInteger index = 1001; index <1004; index++) {
        UIButton *view = (UIButton*)[self.contentView viewWithTag:index];
        view.enabled = NO;
    }
}
- (void)loadAnswerDataForChecked:(NSString*)answer withAnswerscore:(NSInteger)score withPreAnswer:(SingleStudentHomeworkAnswer*)preanswer{
    self.noneSeletorAnswer.delegate = self;
    [self.noneSeletorAnswer loadUrlData:[answer componentsSeparatedByString:@","] withAnswerPic:preanswer.checkPics];
    UIButton *view = (UIButton*)[self.contentView viewWithTag:score+1001];
    view.selected = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)giveEvaluate:(UIButton *)sender {
    for (NSInteger index = 1001; index <1004; index++) {
        UIButton *view = (UIButton*)[self.contentView viewWithTag:index];
        if (view.selected) {
            if (view.tag == sender.tag) {
                sender.selected = !sender.selected;
            }else{
                view.selected = NO;
                sender.selected = !sender.selected;
            }
            break;
        }
        else if (index == 1003){
            sender.selected = !sender.selected;
        }
    }
    if ([self.noneseletorDelegate respondsToSelector:@selector(didToDetail: withIndex:)]) {
        [self.noneseletorDelegate didGiveTheScore:sender.tag - 1001 withIndex:self.index];
    }
}
#pragma mark - ImageGalleryDelegate
- (void)didTouchToDetail:(NSInteger)index{
    if ([self.noneseletorDelegate respondsToSelector:@selector(didToDetail: withIndex:)]) {
        [self.noneseletorDelegate didToDetail:index withIndex:self.index];
    }
}
@end
