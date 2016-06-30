//
//  StudentGroup.m
//  xueyoubangbang
//
//  Created by Bob on 15/8/30.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "StudentGroup.h"

@implementation StudentGroup
- (NSString*)getGroupID{
    return NSIntTOString(self.groupid);
}
- (NSString*)getSubject{
    NSDictionary* subjects =  @{@"1":@"语文",
                  @"2":@"数学",
                  @"3":@"英语",
                  @"4":@"物理",
                  @"5":@"化学",
                  @"6":@"生物",
                  @"7":@"政治",
                  @"8":@"历史",
                  @"9":@"地理"
                  };
    return subjects[[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%ld",self.subjectid]]];
}
@end
