//
//  MessageFinishCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/27.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MessageFinishCell.h"
#import "CheckHomeWorkStudent.h"
#import "NSString+Stackoverflow.h"
@interface MessageFinishCell()
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rankImg;

@end
@implementation MessageFinishCell

- (void)awakeFromNib {
    self.headerImg.layer.masksToBounds = YES;
    self.headerImg.layer.cornerRadius = 17;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)loadData:(CheckHomeWorkStudent*)data withIndex:(NSIndexPath*)index {
    switch (index.row) {
        case 0:
            self.rankImg.hidden = NO;
            self.rankLabel.hidden = YES;
            self.rankImg.image = IMAGE(@"ranking_first_icon");
            break;
        case 1:
            self.rankImg.hidden = NO;
            self.rankLabel.hidden = YES;
            self.rankImg.image = IMAGE(@"ranking_two_icon");
            break;
        case 2:
            self.rankImg.hidden = NO;
            self.rankLabel.hidden = YES;
            self.rankImg.image = IMAGE(@"ranking_three_icon");
            break;
        default:
            break;
    }
    if (index.row>2) {
        self.rankImg.hidden = YES;
        self.rankLabel.hidden = NO;
        self.rankLabel.text = NSIntTOString(index.row +1);
    }
    [self.headerImg sd_setImageWithURL: [NSURL URLWithString:UrlResString(data.headerphoto)] placeholderImage:DEFAULT_HEADER];
    self.nameLabel.text = data.username;
    self.timeLabel.text = [NSString stringWithFormat:@"%@提交",[data.inserttime transTimeWithOriginFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"MM-dd HH:mm"]];
    
}
@end
