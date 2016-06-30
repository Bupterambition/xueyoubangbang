//
//  HomeworkSubmitInfo.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "HomeworkSubmitInfo.h"
#import "SingleStudentHomeworkInfo.h"
@interface HomeworkSubmitInfo()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *submitLabel;

@end
@implementation HomeworkSubmitInfo

- (void)awakeFromNib {
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.submitLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)loadInfo:(SingleStudentHomeworkInfo*)data{
    self.nameLabel.text = data.username;
    self.submitLabel.text = [self changeTimeFormmat:data.submittime];
}


- (void)loadInfo:(NSString*)groupName withScore:(NSString*)score{
    self.nameLabel.text = groupName;
    self.submitLabel.textColor = [UIColor redColor];
    self.submitLabel.text = @{@"1":@"A",@"2":@"B",@"3":@"C",@"4":@"D"}[score==nil?@"0":score];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSString *)changeTimeFormmat:(NSString*)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *newsDateFormatted = [dateFormatter dateFromString:time];
    [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    NSString *test = [dateFormatter stringFromDate:newsDateFormatted];
    return [NSString stringWithFormat:@"%@提交",test];
}

@end
