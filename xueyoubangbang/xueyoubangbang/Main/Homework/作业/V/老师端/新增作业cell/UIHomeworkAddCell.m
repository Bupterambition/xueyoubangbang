//
//  UIHomeworkAddCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkAddCell.h"
#import "NewHomeworkInfo.h"
@implementation UIHomeworkAddCell

- (void)awakeFromNib {
    [self.editImageView addTarget:self action:@selector(didTouchKnowledgePoints) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)didTouchKnowledgePoints{
    if ([self.UIHomeworkAddDelegate respondsToSelector:@selector(addKnowledge)]) {
        [self.UIHomeworkAddDelegate addKnowledge];
    }
}
- (void)loadHomeworkForTitle:(NewHomeworkInfo*)data withIndex:(NSIndexPath*)index{
    switch (index.row) {
        case 0:
            self.editField.text = data.title;
            break;
        case 1:
            self.editField.text = data.submittime?[self changeTimeFormmat:data.submittime]:@"";
            break;
        case 2:
            self.editField.text = data.groupname;
            break;
        case 3:
            self.editField.text = data.knowledgepointsname;
            break;
            
        default:
            break;
    }
}
- (void)loadHomeworkForStudent:(NewHomeworkInfo*)data withIndex:(NSIndexPath*)index{
    switch (index.row) {
        case 0:
            self.editField.text = data.title;
            break;
        case 1:
            self.editField.text = data.submittime?[self changeTimeFormmat:data.submittime]:@"";
            break;
        case 2:
            self.editField.text = data.knowledgepointsname;
            self.editField.enabled = YES;
            break;
            
        default:
            break;
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
