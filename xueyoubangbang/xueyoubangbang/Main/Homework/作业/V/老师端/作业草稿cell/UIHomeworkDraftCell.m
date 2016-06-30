//
//  UIHomeworkDraftCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/7.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkDraftCell.h"
@interface UIHomeworkDraftCell()
@property (weak, nonatomic) IBOutlet UILabel *homeworkTitle;
@property (weak, nonatomic) IBOutlet UILabel *submittedTime;
@property (weak, nonatomic) IBOutlet UILabel *knowledgeLabel;

@end

@implementation UIHomeworkDraftCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadOldHomework:(MHomework *)homework{
    self.homeworkTitle.text = homework.title;
    self.submittedTime.text = [NSString stringWithFormat:@"%@提交",[self changeTimeFormmat:homework.submittime]];
}

- (void)loadNewHomeWork:(NewHomeWorkSend *)homework{
    self.homeworkTitle.text = homework.title;
    self.submittedTime.text = [NSString stringWithFormat:@"%@提交",[self changeTimeFormmat:homework.submittime]];
    self.knowledgeLabel.text = homework.knowledges;
}
- (NSString *)changeTimeFormmat:(NSString*)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *newsDateFormatted = [dateFormatter dateFromString:time];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps;
    comps = [calendar components:unitFlags fromDate:newsDateFormatted];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *test = [dateFormatter stringFromDate:newsDateFormatted];
    return [NSString stringWithFormat:@"%@ %@",test,[self getWeekDay:weekday]];

}

- (NSString *)getWeekDay:(NSInteger)weekday{
    switch (weekday) {
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        case 1:
            return @"周日";
            break;
        default:
            return nil;
            break;
    }
}
- (IBAction)didTouchDeleteDraft:(UIButton *)sender {
    if ([self.draftDelegate respondsToSelector:@selector(didTouchDraftDelete:)]) {
        [self.draftDelegate didTouchDraftDelete:self.currentIndexPath];
    }
}

@end
