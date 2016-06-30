//
//  UIHomeworkMainCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/6.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkMainCell.h"
#import "NSString+Stackoverflow.h"
@implementation UIHomeworkMainCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)touchCurrentCell:(UIButton *)sender {
    if ([self.homeCellDelegate respondsToSelector:@selector(didTouchButton:)]) {
        [self.homeCellDelegate didTouchButton:self.currentIndex];
    }
}
- (void)loadNewHomeWorkData:(NewHomeWork *)home{
    _className.text = home.groupname;
    _finishTime.text = [home.finishtime transTimeWithOriginFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"MM-dd HH:mm"];
    _workDescription.text = home.title;
    _dayleft.text = [self calculateLeftTime:[self getUTCFormateDate:home.finishtime] withNewHomeWorkData:home];
//    _dayleft.text = [NSString stringWithFormat:@"剩余%ld天",home.dayleft];
//    else
//        _dayleft.text = [self calculateLeftTime:[self getUTCFormateDate:home.submittime] withNewHomeWorkData:home];
    _unfinishedCount.text = [NSString stringWithFormat:@"%ld",home.finishnum];
    _totalLabel.text = [NSString stringWithFormat:@"/%@",home.totalnum];
}

/**
 *  得到剩余时间的数组数据
 *
 *  @param inDate   剩余时间，由作业数据提供
 *  @param inFormat 时间格式
 *
 *  @return 剩余时间的数组数据（当第一个元素为0，表示未完成，第二个元素表示剩余的是天数or小时）
 */
- (NSArray *)getUTCFormateDate:(NSString *)inDate
{
    //    newsDate = @"2013-08-09 17:01";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSLog(@"newsDate = %@",inDate);
    NSDate *newsDateFormatted = [dateFormatter dateFromString:inDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate* current_date = [[NSDate alloc] init];
    
    NSTimeInterval time=[newsDateFormatted timeIntervalSinceDate:current_date];//间隔的秒数
    //    int month=((int)time)/(3600*24*30);
    NSInteger days=((int)time)/(3600*24);
    NSInteger hours=((int)time)%(3600*24)/3600;
    NSInteger minute=((int)time)%(3600*24)%3600/60;
    //    NSLog(@"time=%d",(double)time);
    
    NSString *dateContent = @"剩余小时";
    
    
    NSInteger number = 0;
    if(days > 0){
        number = days ;
        dateContent = @"剩余天数";
    }else if(hours > 0){
        number = hours;
        dateContent = @"剩余小时";
    }
    else if (minute > 0) {
        number = minute;
        dateContent = @"剩余分钟";
    }
    
    return @[[NSString stringWithFormat:@"%ld",number],dateContent];
}
/**
 *  返回需要显示的剩余时间数据
 *
 *  @param timearry 剩余时间数组
 *  @param mh       旧作业时间函数
 *
 *  @return 返回需要显示的剩余时间数据
 */
- (NSString *)calculateLeftTime:(NSArray*)left withOldHomeWorkData:(MHomework*)mh{
    if([mh.status isEqualToString:@"0"])
    {
        if( [@"0" isEqualToString:left[0]])
        {
            return @"未完成";
        }
        else
        {
            if( [@"剩余天数" isEqualToString :[left objectAtIndex:1] ])
            {
                return [NSString stringWithFormat:@"剩余%@天",left[0]];
            }
            else if ([@"剩余小时" isEqualToString :[left objectAtIndex:1] ])
            {
                return [NSString stringWithFormat:@"剩余%@小时",left[0]];
            }
            else{
                return [NSString stringWithFormat:@"剩余%@分钟",left[0]];
            }
            
        }
    }
    else if ([mh.status isEqualToString:@"1"])
    {
        //已完成
        return @"已完成";
    }
    else
    {
        return @"未完成";
    }
}
/**
 *  返回需要显示的剩余时间数据
 *
 *  @param timearry 剩余时间数组
 *  @param mh       旧作业时间函数
 *
 *  @return 返回需要显示的剩余时间数据
 */
- (NSString *)calculateLeftTime:(NSArray*)left withNewHomeWorkData:(NewHomeWork*)mh{
    if([mh.status isEqualToString:@"0"])
    {
        if( [@"0" isEqualToString:left[0]])
        {
            return @"已截止";
        }
        else
        {
            if( [@"剩余天数" isEqualToString :[left objectAtIndex:1] ])
            {
                return [NSString stringWithFormat:@"剩余%@天",left[0]];
            }
            else if ([@"剩余小时" isEqualToString :[left objectAtIndex:1] ])
            {
                return [NSString stringWithFormat:@"剩余%@小时",left[0]];
            }
            else{
                return [NSString stringWithFormat:@"剩余%@分钟",left[0]];
            }
            
        }
    }
    else if ([mh.status isEqualToString:@"1"])
    {
        //已完成
        return @"已完成";
    }
    else
    {
        return @"已截止";
    }
}
@end
