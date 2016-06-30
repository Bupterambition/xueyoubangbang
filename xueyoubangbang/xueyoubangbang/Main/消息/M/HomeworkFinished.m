//
//  HomeworkFinished.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "HomeworkFinished.h"
#import "NSDate+Format.h"
@implementation HomeworkFinished
- (NSString*)getSubject{
    NSDictionary* subjects =  @{@"1":@"语文",
                                @"2":@"数学",
                                @"3":@"英语",
                                @"4":@"物理",
                                @"5":@"化学",
                                @"6":@"生物",
                                @"7":@"政治",
                                @"8":@"历史",
                                @"9":@"地理",
                                @"0":@"语文"
                                };
    return subjects[[NSString stringWithFormat:@"%@",self.subject_id]];
}
- (NSString*)remind_time{
    if (_remind_time != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *newsDateFormatted = [dateFormatter dateFromString:_remind_time];
      //  NSLog(@"%@",[newsDateFormatted format:@"YY:MM 分"]);
        return [newsDateFormatted format:@"MM-dd HH:mm"];
    }
    return @"";
}
@end
