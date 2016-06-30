//
//  MissTableViewCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/26.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MissTableViewCell.h"
@interface MissTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@end
@implementation MissTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(NSArray*)data withValidDays:(NSArray*)days withIndex:(NSIndexPath*)index{
    NSInteger __block highPercent90=0;
    NSInteger __block highPercent50=0;
    NSInteger __block lowPercent50=0;
    [data enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([obj integerValue] >= 90) {
            if ([days[idx] isEqualToString:@"1"]) {
                highPercent90 ++;
            }
        }
        else if ([obj integerValue] >= 50) {
            if ([days[idx] isEqualToString:@"1"]) {
                highPercent50 ++;
            }
        }
        else if ([obj integerValue] < 50){
            if ([days[idx] isEqualToString:@"1"]) {
                lowPercent50 ++;
            }
        }
    }];
    switch (index.row) {
        case 0:
            self.desLabel.text = @"本月正确率高于90%";
            self.dayLabel.text = [NSString stringWithFormat:@"%ld天",highPercent90];
            break;
        case 1:
            self.desLabel.text = @"本月正确率高于50%";
            self.dayLabel.text = [NSString stringWithFormat:@"%ld天",highPercent50];
            break;
        case 2:
            self.desLabel.text = @"本月正确率低于50%";
            self.dayLabel.text = [NSString stringWithFormat:@"%ld天",lowPercent50];
            break;
        default:
            break;
    }
}

@end
