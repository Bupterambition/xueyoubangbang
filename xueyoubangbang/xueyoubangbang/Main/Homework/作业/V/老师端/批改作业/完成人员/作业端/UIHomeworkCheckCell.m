//
//  UIHomeworkCheckCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkCheckCell.h"
#import "CheckHomeWorkStudent.h"
@interface UIHomeworkCheckCell()
@property (weak, nonatomic) IBOutlet UILabel *studentName;
@property (weak, nonatomic) IBOutlet UILabel *homeworkTitle;
@property (weak, nonatomic) IBOutlet UILabel *submitTime;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;

@end
@implementation UIHomeworkCheckCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)loadData:(CheckHomeWorkStudent*)data withHomeworkTitle:(NSString*)title{
    self.studentName.text = data.username;
    self.homeworkTitle.text = title;
    self.submitTime.text = [self changeTimeFormmat:data.inserttime];
    if ([data.homeworkchecked isEqualToString:@"1"]) {
        self.checkLabel.hidden = NO;
    }
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
@end
