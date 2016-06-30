//
//  HomeworkChecked.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "HomeworkChecked.h"
#import "NSDate+Format.h"
@implementation HomeworkChecked
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

@end
