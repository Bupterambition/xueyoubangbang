//
//  ApplyForGroup.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "ApplyForGroup.h"
#import "NSDate+Format.h"
@implementation ApplyForGroup
- (NSString*)remind_time{
    if (_remind_time != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
//        [dateFormatter setTimeZone:timeZone];
        NSDate *newsDateFormatted = [dateFormatter dateFromString:_remind_time];
        return [newsDateFormatted format:@"MM-dd HH:mm"];
    }
    return @"";
}
@end
