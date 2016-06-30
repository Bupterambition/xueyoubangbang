//
//  MessageObject.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MessageObject.h"

@implementation MessageObject
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"question" : @"Question",
             @"homeworkToDo" : @"HomeworkToDo",
             @"homeworkChecked" : @"HomeworkChecked",
             @"applyForGroup" : @"ApplyForGroup",
             @"applyForFriends" : @"ApplyForFriends",
             @"homeworkFinished" : @"HomeworkFinished"
             };
}
- (NSInteger)getAllMessageNum{
    return _question.count + _homeworkToDo.count + _homeworkChecked.count + _applyForGroup.count + _applyForFriends.count +_homeworkFinished.count;
}
@end
