//
//  NSDate+Format.m
//  client
//
//  Created by sdzhu on 15/3/30.
//  Copyright (c) 2015年 supaide. All rights reserved.
//

#import "NSDate+Format.h"

@implementation NSDate(Format)
- (NSString *)format:(NSString *)format
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    NSString *result = [df stringFromDate:self];
    return result;
}
@end
