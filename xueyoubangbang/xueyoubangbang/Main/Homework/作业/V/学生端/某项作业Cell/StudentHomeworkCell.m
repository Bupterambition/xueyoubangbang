//
//  StudentHomeworkCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "StudentHomeworkCell.h"
#import "NewHomeWork.h"
#import "NewHomeworkItem.h"
@interface StudentHomeworkCell()
/**
 *  检测是否已经批改完毕
 */
//@property (weak, nonatomic) IBOutlet UIImageView *timeToChangeView;
/**
 *  剩余时间也可以用于点击
 */
//@property (weak, nonatomic) IBOutlet UILabel *LeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeworkName;
@property (weak, nonatomic) IBOutlet UILabel *unfinishLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishTime;
@property (weak, nonatomic) IBOutlet UILabel *holdLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end
@implementation StudentHomeworkCell

- (void)awakeFromNib {
    self.holdLabel.layer.masksToBounds = YES;
    self.holdLabel.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)loadNewHomeWorkData:(NewHomeWork *)home{
    _rightBtn.enabled = NO;
    _finishTime.text = [self transferTime:home.finishtime];
    _homeworkName.text = home.title;
    _unfinishLabel.text = [NSString stringWithFormat:@"%ld/%@",home.finishnum,home.totalnum];
//    _timeToChangeView.hidden = NO;
    if (home.ischecked == 0) {
        if ([home.status  isEqual: @"0"]) {
            if (home.dayleft < 0) {
                [_rightBtn setTitle:@"已经截止" forState:UIControlStateNormal];
//                _LeftLabel.text = @"已经截止";
                [_rightBtn setImage: IMAGE(@"time") forState:UIControlStateNormal];
                [_rightBtn setTitleColor:STYLE_COLOR forState:UIControlStateNormal];
//                _timeToChangeView.image = IMAGE(@"time");
//                _LeftLabel.textColor = [UIColor redColor];
                [NewHomeworkItem saveListModel:nil forKey:home.homework_id];
            }
            else{
//                _LeftLabel.text = [NSString stringWithFormat:@"剩余%ld天",home.dayleft];
//                _timeToChangeView.image = IMAGE(@"time");
//                _LeftLabel.textColor = [UIColor redColor];
//                _LeftLabel.text = [self calculateLeftTime:[self getUTCFormateDate:home.submittime] withNewHomeWorkData:home];
                [_rightBtn setTitle:[self calculateLeftTime:[self getUTCFormateDate:home.submittime] withNewHomeWorkData:home] forState:UIControlStateNormal];
                [_rightBtn setImage: IMAGE(@"time") forState:UIControlStateNormal];
            }
        }
        else{
//            _timeToChangeView.hidden = YES;
//            _LeftLabel.text = @"已提交";
//            _LeftLabel.textColor = RGB(0,161,142);
            [_rightBtn setTitle:@"已提交" forState:UIControlStateNormal];
            [_rightBtn setImage: nil forState:UIControlStateNormal];
            [_rightBtn setTitleColor:RGB(0,161,142) forState:UIControlStateNormal];
        }
    }
    else{
        _rightBtn.enabled = YES;
        [_rightBtn setTitle:@"查看批改" forState:UIControlStateNormal];
        [_rightBtn setImage:IMAGE(@"down_green") forState:UIControlStateNormal];
        [_rightBtn setTitleColor:STYLE_COLOR forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(checkReview) forControlEvents:UIControlEventTouchUpInside];
//        _LeftLabel.text = @"查看批改";
//        _LeftLabel.textColor = RGB(0,161,142);
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkReview)];
//        _LeftLabel.userInteractionEnabled = YES;
//        [_LeftLabel addGestureRecognizer:tap];
//        _timeToChangeView.image = IMAGE(@"down_green");
    }
}

- (void)checkReview{
    if ([self.studentHomeworkCellDelegate respondsToSelector:@selector(didToReview:)]) {
        [self.studentHomeworkCellDelegate didToReview:self.index.section];
    }
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
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
//    [dateFormatter setTimeZone:timeZone];
    
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
- (NSString*)transferTime:(NSString*)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *newsDateFormatted = [dateFormatter dateFromString:time];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
//    [dateFormatter setTimeZone:timeZone];
    NSLog(@"%@",[dateFormatter stringFromDate:newsDateFormatted]);
    return [dateFormatter stringFromDate:newsDateFormatted];
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
@end
