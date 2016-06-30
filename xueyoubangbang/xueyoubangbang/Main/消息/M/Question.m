//
//  Question.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "Question.h"
#import "NSDate+Format.h"
@implementation Question
- (NSString*)remind_time{
    if (_remind_time != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *newsDateFormatted = [dateFormatter dateFromString:_remind_time];
       // NSLog(@"%@",[newsDateFormatted format:@"YY:MM 分"]);
        return [newsDateFormatted format:@"MM-dd HH:mm"];
    }
    return @"";
}
@end
